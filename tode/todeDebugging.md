#Debugging Gem Servers with tODE

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

The standard **GemServer** snaps off a continuation whenever an error is encountered. 
It is possible to bring up the debugger on the continuation "after the fact" and this is very useful for characterizing bugs that may show up in production.
However, for development it is preferable to be able to debug gem server errors in tODE.

While server code is run in tODE the tODE GUI process will be blocked, therefore it is necessary to initiate client-side requests from a second tODE image.
Also, gem servers must be run in #manualBegin transaction mode to avoid large commit record backlog, while tODE normally runs in #autoBegin transaction mode.



##Installation
Open a full-size tODE client and install GsApplicationTools using the following tODE expressions:

```Shell
project entry --baseline=GsApplicationTools --repo=github://GsDevKit/gsApplicationTools/repository \
        /sys/stone/projects
project load --loads='CI' GsApplicationTools
mount @/sys/stone/dirs/GsApplicationTools/tode /home gemserver
```
##
## 
2. Open two *small* tODE clients, positioning them to split the screen: client on top half and server on bottom half. 
  Use the *alternate-large* window layout.
  You might want to open a third tODE client full screen to do development in.
  Whenever you switch to a new client, it doesn't hurt to run the `abort` command in the tODE shell window to make sure that you are sharing the latest committed work.
3. Open a shell window against your stone in your tODE clients.
4. In the client window start by mounting the tODE directory that contains the scripts and this document:
  ```Shell
  ```