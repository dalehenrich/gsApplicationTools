#Debugging Gem Servers with tODE

In this tutorial we will go over the steps necessary to debug a gem server using tODE.

When debugging a gem server in tODE, [the UI process is blocked](#gemstone-processes-and-gci), which means that it is necessary to run two tODE images: one running as the client and one running as the server.

Let's open two *small* tODE clients and position the client image on the top half of the screen and the server image on bottom half of the screen. 
Use the *alternate-large* window layout (**tODE>>tODE Window Layout>>alternate-large** menu item).
The **alternate** layouts are designed to be useable with minimal vertical screen real estate.

While the half-screen images are usable for running client and server code, it is convenient to have a third tODE client that is opened to full screen size for reading and writing code.
When running with multiple tODE clients connected to the same stone, remember to use the tODE `abort` command whenever you start work in a different tODE client.

##Gem Server Installation
Use the following tODE expressions to install the **GemServer** support code and a set of example gem servers:

```Shell
project entry --baseline=GsApplicationTools --repo=github://GsDevKit/gsApplicationTools/repository \
        /sys/stone/projects
project load --loads='CI' GsApplicationTools
mount @/sys/stone/dirs/GsApplicationTools/tode /home gemserver
```

##GemStone Processes and GCI

In order for GemStone Smalltalk code to execute in a GCI[1] application like tODE, the client process must make a blocking or non-blocking GCI call. 
However, one is not allowed to make multiple, concurrent GCI calls to execute Smalltalk code for the same gem process, so in effect the GCI interface is single threaded with respect to executing GemStone Smalltalk code.
Since nearly all of tODE's functionality is implemented in GemStone Smalltalk code, it is not practical to allow developers to do much other than wait for processing to complete on the gem.
tODE uses a non-blocking GCI call to initiate execution of GemStone Smalltalk code and spins in a restless loop polling for the result making it possible to interrupt GemStone processing by using the ALT-. key combination.



##EXTRAS ... eventually deleted

Gem servers are designed to run as stand-alone topaz sessions in **#manualBegin** transaction mode, which is quite different than an interactive tODE session that runs in **#autoBegin** transaction mode.







The following tODE expressions puts a tODE session into **#manualBegin** and turns off auto-commit (which isn't useful in **#manualBgin** mode):

```Shell
eval `System transactionMode: #manualBegin`
limit autoCommit false
```



A gem server is designed to run in a stand-alone topaz session.
To avoid a commit record backlog gem servers are run in **#manualBegin** transaction mode.

The standard **GemServer** snaps off a continuation whenever an error is encountered. 
It is possible to bring up the debugger on the continuation "after the fact" and this is very useful for characterizing bugs that may show up in production.
However, for development it is preferable to be able to debug gem server errors in tODE.


While server code is run in tODE the tODE GUI process will be blocked, therefore it is necessary to initiate client-side requests from a second tODE image.
Also, gem servers must be run in #manualBegin transaction mode to avoid large commit record backlog, while tODE normally runs in #autoBegin transaction mode.

In this tutorial we will be using the class **GemServerRemoteServerTransactionModelBExample** as our example gem server. This gem server operates by taking tasks off of an RcQueue and processes each task in a separate thread:

```Smalltalk
processTasksOnQueue
  | tasks |
  self
    doSimpleTransaction: [ 
      tasks := self queue removeAll.
      self inProcess addAll: tasks ].
  self trace: [ 'tasks [1] ' , tasks size printString ] object: [ tasks copy ].
  tasks
    do: [ :task | 
      | proc |
      self trace: [ 'fork task [2] ' , task label ] object: [ task ].
      proc := TransientStackValue
        value: (self taskServiceThreadBlock: task) fork.
      activeProcessesMutex critical: [ self activeProcesses add: proc value ].
      self
        trace: [ 
          'task [5] inProcess: ' , self inProcess size printString , ' activeProcesses: '
            , self activeProcesses size printString ]
        object: [ self status ].
      Processor yield ]
```

The forked thread runs in a transaction, so it is not necessary to do any additional transaction management:  

```Smalltalk
taskServiceThreadBlock: task
  "use GemServer>>gemServerTransaction:exceptionSet:onError: to wrap a transaction around 
   the gemServerTransaction and onError blocks ... 'seaside-stye' transaction model"

  ^ [ 
  [ 
  self
    gemServerTransaction: [ 
      "handle exceptions (including breakpoints and Halt) that occur while processing individual task"
      self trace: [ 'start process task [3] ' , task label ] object: [ task ].
      [ task processTask: self ]
        ensure: [ 
          self inProcess remove: task.
          self trace: [ 'end process task [4] ' , task label ] object: [ task ] ] ]
    exceptionSet:
      GemServerRemoteInternalServerErrorTriggerExample , self gemServerExceptionSet
    onError: [ :ex | 
      task exception: ex.
      (ObjectLogEntry
        error: 'Server example task exception: ' , ex description printString
        object: task) addToLog ] ]
    ensure: [ 
      activeProcessesMutex
        critical: [ self activeProcesses value remove: Processor activeProcess ifAbsent: [  ] ] ] ]
```

---

[1]: http://downloads.gemtalksystems.com/docs/GemStone64/3.2.x/GS64-GemBuilderforC-3.2.pdf