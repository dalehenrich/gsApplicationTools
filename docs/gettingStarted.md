# Getting started with Gem Servers

##Table of Contents
- [What is a Gem Server](#what-is-a-gem-server)
  - [Topaz](#topaz)
    - [Topaz Execution Environment](#topaz-execution-environment)
      - [Block Main Process](#block-main-process)
      - [Exception Handler protecting forked blocks](#exception-handler-protecting-forked-blocks)
      - [Exceptions to Handle in Topaz](#exceptions-to-handle-in-topaz)
    - [Topaz Transaction Modes](#topaz-transaction-modes)
- [GemServer class](#gemserver-class)
  - [GemServerRegistry class](#gemserverregistry-class)
  - [Gem Server Service Loop](#gem-server-service-loop)
  - [Gem Server Exception Handling](#gem-server-exception-handling)
    - [Gem Server Exception Set](#gem-server-exception-set)
    - [Gem Server Exception Handlers](#gem-server-exception-handlers)
    - [Gem Server `beforeUnwindBlock`](#gem-server-beforeunwindblock)
    - [Gem Server Exception Logging](#gem-server-exception-logging)
    - [Gem Server `ensureBlock`](#gem-server-ensureblock)
  - [Gem Server Transaction Management](#gem-server-transaction-management)
    - [Basic Gem Server Transaction Support](#basic-gem-server-transaction-support)
      - [`doBasicTransaction:`](#dobasictransaction)
      - [`doTransaction:onConflict:`](#dotransactiononconflict)
      - [`doTransaction:`](#dotransaction)
    - [Practical Gem Server Transaction Support](#practical-gem-server-transaction-support)
      - [Request/Response Gem Server Tasks](#requestresponse-gem-server-tasks)
      - [I/O Gem Server Tasks](#io-gem-server-tasks)
  - [Gem Server Control](#gem-server-control)
    - [Gem Server Control from Smalltalk](#gem-server-control-from-smalltalk)
    - [Gem Server Bash scripts](#gem-server-bash-scripts)
      - [Gem Server start script](#gem-server-start-script)
      - [Gem Server stop script](#gem-server-stop-script)
  - [Gem Server Debugging](#gem-server-debugging)
    - [Object Log Debugging](#object-log-debugging)
    - [Interactive Debugging](#interactive-debugging)
      - [Interactive Debugging Example](#interactive-debugging-example)
- [Glossary](#glossary)

---

##What is a Gem Server

A *gem server* is a [Topaz session](#gemstone-session) that executes an *application-specific service loop*.

###Topaz

The [Topaz][2] execution model is very different from the typical Smalltalk execution model:

>> Topaz is a GemStone programming environment that provides keyboard command access
>> to the GemStone system. Topaz does not require a windowing system and so is a useful,
>> interface for batch work and for many system administration functions.

Smalltalk code is executed in [Topaz][2] using the `run` command:

```
run
  3+4
%
```

Control returns to the [Topaz][2] console when the Smalltalk code itself returns, or an *unhandled exceptions* is encountered.
When control returns to the console, Smalltalk execution is halted until another [Topaz][2] command is executed.
If the last `run` section has been encountered the [Topaz][2] process exits.

####Topaz Execution Environment

For *gem server* code to be run in [Topaz][2] you need to do two things:
  1. Ensure that the main Smalltalk process blocks and does not return.
  2. Ensure that all exceptions are handled, including exceptions signalled in processes that have been forked from the main Smalltalk process.

#####Block Main Process
In essence this entails structuring your *application-specific service loop* to look something like the following:

```
run
  [ true ]
    whileTrue: [
      [ "application service loop code" ]
        on: exceptionSet
        do: [:ex | "handle the exception and continue processing" ] ].
%
```

The main Smalltalk process is blocked by the infinite `whileTrue:` loop.
The exception handler is protecting the `"application service loop code"`, so we shouldn't have an *unhandled exception*, as long as the *exceptionSet* is covering the [proper set of exceptions](#exceptions-to-handle-in-topaz).

#####Exception Handler protecting forked blocks
If we are forking blocks, each of the forked processes must have an exception handler near the top of the stack to guard against *unhandled exceptions* that looks like the following:

```Smalltalk
[ 
[ "forked application code" ]
    on: exceptionSet
    do: [:ex | "handle the exception and continue processing" ] ] fork
```

#####Exceptions to Handle in Topaz
In a [Topaz][2] process, exception handlers should be defined to handle the following exceptions:
  - **AlmostOutOfMemory** - Notication signalled when a percent [temporary object space](#temporary-object-space) threshold is exceeded. The [Topaz][2] process will be terminated if [temporary object space](#temporary-object-space) is completely consumed. A typical handler will do a commit to cause persistent objects to be flushed from [temporary object space](#temporary-object-space) to disk. If a significant amount of [temporary object space](#temporary-object-space) is being consumed on the stack, then logging a stack trace and unwinding the stack may be called for. 
  - **AlmostOutOfStack** - Notification signaled when the size of the current execution stack is about to exceed the [max execution stack depth](#gem_max_smalltalk_stack_depth). Again, the [Topaz][2] process will be terminated if the notification is not heeded. A typical handler will log a stack trace and unwind the stack.
  - **Error** - Most **Error** exceptions are going to be handled by error handlers in the application code itself, but it is prudent to provide a backstop exception handler for unanticipated error conditions. The typical error handler should log the stack trace and unwind the stack.
  - **TransactionBacklog** - If signalling is enabled, a typical handler will do an abort. If signalling is not enabled and/or an abort is not performed in a timely manner, then the session will be forcibly terminated.

####Topaz Transaction Modes

A [Topaz session](#gemstone-session) may run in one of two transaction modes:
  - [automatic transaction mode](#automatic-transaction-mode)
  - [manual transaction mode](#manual-transaction-mode)

In [automatic transaction mode](#automatic-transaction-mode), the system is always *in transaction*. When either a [commit transaction](#commit-transaction) or an [abort transaction](#abort-transaction) is performed, the system automatically updates the transactional view of the system and leaves the system *in transaction*.
An explicit [begin transaction](#begin-transaction) is not needed.

In [manual transaction mode](#manual-transaction-mode) it is necessary to explicitly to start each transaction with a [begin transaction](#begin-transaction) and terminate each transaction with either a [commit transaction](#commit-transaction) or an [abort transaction](#abort-transaction). 
The transactional view is only updated when a [begin transaction](#begin-transaction) is performed and the system is put *in transaction*. 
It is an error to perform a [commit transaction](#commit-transaction) unless preceded by a [begin transaction](#begin-transaction).
An [abort transaction](#abort-transaction) updates the transaction view, but does not start a transaction.

See the [Gem Server Transaction Management](#gem-server-transaction-management) for a description of the *gem server* transaction options.

---

##GemServer class
As the preceding sections have highlighted, there are several issues in the area of *server exception handling* and *server transaction management* that are unique to the GemStone Smalltalk environment.
The **GemServer** class provides a concise framework for standardized:
  - [service loop definition](#gem-server-service-loop)
  - [exception handling services](#gem-server-exception-handling)
  - [transaction management](#gem-server-transaction-management)
  - [gem server control](#gem-server-control)
  - [gem server logging](#gem-server-exception-logging)
  - [gem server debugging](#gem-server-debugging)

---

###GemServerRegistry class
The **GemServerRegistry** class provides a registry of named *gem servers*.
A *gem server* named instance is created by using the `register:` method:

```Smalltalk
GemServerTestServer register: 'testServer'.
```

Once an instance has been registered, it may be accessed from the **GemServerRegistry** using the `gemServerNamed:` method:

```Smalltalk
(GemServerRegistry gemServerNamed: gemName)
```

---

###Gem Server Service Loop
A *gem server* is associated with one or more ports (a port may be nil).

One [Topaz session](#gemstone-session) is launched for each of the *ports* associated with a *gem server*.

The *gem server* instance is shared by each of the *[Topaz][2] gems*.

The *gem server* is launched by calling the [gem server start script](#gem-server-start-script).
The [script](#gem-server-start-script) executes the following Smalltalk code to start the *gem server*:

```Smalltalk
(GemServerRegistry gemServerNamed: '<gemServerName>') scriptStartServiceOn: <portNumberOrNil>.
```

The `scriptStartServiceOn:` method:

```Smalltalk
scriptStartServiceOn: portOrNil
  "called from shell script"

  self
    scriptServicePrologOn: portOrNil;
    startServerOn: portOrNil	"does not return"
```

The `startServerOn:` method is expected to block the main Smalltalk process in the *gem*:

```Smalltalk
startServerOn: portOrNil
  "start server in current vm. Not expected to return."

  self startBasicServerOn: portOrNil.
  [ true ] whileTrue: [ (Delay forSeconds: 10) wait ]
```

The `startBasicServerOn:` method forks a process to run the `basicServerOn:` method:
```Smalltalk
startBasicServerOn: portOrNil
  "start basic server process in current vm. fork and record forked process instance. expected to return."

  self basicServerProcess: [ self basicServerOn: portOrNil ] fork.
  self serverInstance: self	"the serverProcess is session-specific"
```

The `basicServerOn:` method is expected to be implemented by a concrete subclass of **GemServer**.
For example, here's the `basicServerOn:` method for the [maintenance vm](#maintenance-vm):

```Smalltalk
basicServerOn: port
  "forked by caller"

  | count |
  count := 0.
  [ true ]
    whileTrue: [ 
      self
        gemServer: [ 
          "run maintenance tasks"
          self taskClass performTasks: count ].
      (Delay forMilliseconds: self delayTimeMs) wait.	"Sleep for a minute"
      count := count + 1 ]
```

---

###Gem Server Exception Handling
The `gemServer:exceptionSet:beforeUnwind:ensure:` method implements the basic exception handling logic for the **GemServer** class:

```Smalltalk
gemServer: aBlock exceptionSet: exceptionSet beforeUnwind: beforeUnwindBlock ensure: ensureBlock
  [ 
  ^ aBlock
    on: exceptionSet
    do: [ :ex | 
      | exception |
      [ 
      "only returns if an error was logged"
      exception := ex.
      self handleGemServerException: ex.
      beforeUnwindBlock value: exception ]
        on: Error
        do: [ :unexpectedError | 
          "error while handling the exception"
          self
            serverError: unexpectedError
            titled: self name , ' Internal Server error handling exception: '.
          beforeUnwindBlock value: unexpectedError.
          self doInteractiveModePass: unexpectedError.
          exception return: nil	"unwind stack" ].
      self doInteractiveModePass: exception.
      exception return: nil	"unwind stack" ] ]
    ensure: ensureBlock
```

The exception handling block in this method has been structured to allow for a number of customizations:
  1. The `exceptionSet` argument allows you to specify the set of [exceptions to be handled](#gem-server-exception-set).
  2. The `GemServer>>handleGemServerException:` method invokes [a custom exception handling method](#gem-server-exception-handlers).
  3. If the `GemServer>>handleGemServerException:` method returns, the [`beforeUnwindBlock`](#gem-server-beforeunwindblock) is invoked.
  4. If the [`beforeUnwindBlock`](#gem-server-beforunwindblock) returns and the *gem server* was started during an [interactive debugging session](#interactive-debugging) the `GemServer>>doInteractiveModePass:` method sends `pass` to the exception so that a debugger will be opened.
  6. In a non-interactive session, the `return:` message send causes the stack to unwind.
  7. If an error occures while processing steps 3 and 4, the [error is logged](#gem-server-exception-logging), the exception is passed if in an [interactive debugging session](#interactive-debugging) and the stack is unwound.
  8. Lastly the [`ensureBlock`](#gem-server-ensureBlock) is invoked upon return from the method.

There are several variants of the `GemServer>>gemServer:exceptionSet:beforeUnwind:ensure:` method that allow you to specify only the attributes that you need:
  - gemServer:
  - gemServer:beforeUnwind:
  - gemServer:beforeUnwind:ensure:
  - gemServer:ensure:
  - gemServer:exceptionSet:
  - gemServer:exceptionSet:beforeUnwind:
  - gemServer:exceptionSet:beforeUnwind:ensure:
  - gemServer:exceptionSet:ensure:

####Gem Server Exception Set
Default exception handling has been defined for the following exceptions (the list of default exceptions is slightly different for [GemStone 2.4.x][8]):
  - **Error**
  - **Break**
  - **Breakpoint**
  - **Halt**
  - **AlmostOutOfMemory**
  - **AlmostOutOfStack** 

####Gem Server Exception Handlers
The *gem server* uses [double dispatching][9] to invoke exception-specific handling behavior.
The primary method `exceptionHandlingForGemServer:` is sent by the `GemServer>>handleGemServerException:` method:

```Smalltalk
handleGemServerException: exception
  "if control is returned to receiver, then exception is treated like an error, i.e., 
   the beforeUnwindBlock is invoked and stack is unwound."

  ^ exception exceptionHandlingForGemServer: self
```

The `exceptionHandlingForGemServer:` has been implemented in the [default exception classes](#gem-server-exception-set).
The following secondary methods have been defined in the **GemServer** class:
  - gemServerHandleAlmostOutOfMemoryException:
  - gemServerHandleAlmostOutOfStackException:
  - gemServerHandleBreakException:
  - gemServerHandleBreakpointException:
  - gemServerHandleErrorException:
  - gemServerHandleHaltException:
  - gemServerHandleNonResumableException:
  - gemServerHandleNotificationException:
  - gemServerHandleResumableException:

For an **Error** exception, the `GemServer>>gemServerHandleErrorException:` method is invoked:

```Smalltalk
gemServerHandleErrorException: exception
  "log the stack trace and unwind stack, unless in interactive mode"

  self
    logStack: exception
    titled:
      self name , ' ' , exception class name asString , ' exception encountered: '.
```

the [exception is logged](#gem-server-exception-logging) and the method returns.

For a resumable **Exception**, the `GemServer>>gemServerHandleResumableException:` method is invoked:

```Smalltalk
gemServerHandleResumableException: exception
  "in interactive mode pass exception without logging.
   Otherwise, log the stack trace and then resume the exception."

  self doInteractiveModePass: exception.
  self
    logStack: exception
    titled:
      self name , ' ' , exception class name asString , ' exception encountered: '.
  exception resume
```

As in the case of handling an **Error** the [exception is logged](#gem-server-exception-logging), but instead of returning, the exception is resumed and processing continues uninterrupted.

####Gem Server `beforeUnwindBlock`
The `beforeUnwindBlock` gives you a chance to perform application specific operations before the stack is unwound.
For example, a web server may want to return a 4xx or 5xx HTTP response in the event of an error:

```Smalltalk
handleRequest: request for: socket
  self
    gemServer: [ ^self processRequest: request for: socket ]
    beforeUnwind: [ :ex | ^ self writeServerError: ex to: socket ]
```

If your *gem server* needs custom handling for an exception, you can add new `gemServerHandle*` methods or override existing `gemServerHandle*` methods.

####Gem Server Exception Logging
When an exception is handled, the stack is written to the gem log and a continuation for the stack is saved to the [object log](#object-log) by the `logStack:titled:inTransactionDo:` method:

```Smalltalk
logStack: exception titled: title inTransactionDo: inTransactionBlock
  self writeGemLogEntryFor: exception titled: title.
  self
    saveContinuationFor: exception
    titled: title
    inTransactionDo: inTransactionBlock
```

The `writeGemLogEnryFor:titled:` dumps a stack to the gem log.
This method is called first to ensure that a record of the error has been written to disk in the event the continuation fails to be committed:

```Smalltalk
writeGemLogEntryFor: exception titled: title
  | stream stack |
  stack := GsProcess stackReportToLevel: self stackReportLimit.
  stream := WriteStream on: String new.
  stream nextPutAll: '----------- ' , title , DateAndTime now printString.
  stream lf.
  stream nextPutAll: exception description.
  stream lf.
  stream nextPutAll: stack.
  stream nextPutAll: '-----------'.
  stream lf.
  GsFile gciLogServer: stream contents
```

The `saveContinuationFor:titled:inTransactionDo:` method arranges to create the continuation within it's own transaction or within an existing transaction:

```Smalltalk
saveContinuationFor: exception titled: title inTransactionDo: inTransactionBlock
  | label |
  label := title , ': ' , exception description.
  System inTransaction
    ifTrue: [ 
      self createContinuation: label.
      inTransactionBlock value ]
    ifFalse: [ 
      self
        doTransaction: [ 
          self createContinuation: label.
          inTransactionBlock value ] ]
```

The `serverError:titled:` method calls `logStack:titled:inTransactionDo:` and allows for [interactive debugging](#interactive-debugging) of the exception:

```Smalltalk
serverError: exception titled: title inTransactionDo: inTransactionBlock
  self
    logStack: exception
    titled: title , ' Server error encountered: '
    inTransactionDo: inTransactionBlock.
  self doInteractiveModePass: exception
```

####Gem Server `ensureBlock`
The `ensureBlock` gives you a chance to make sure that any resources used by the application within the scope of the `gemServer:*` call are cleaned up.
For example, a web server may want to close sockets when processing is finished:

```Smalltalk
handleRequest: request for: socket
  self
    gemServer: [ ^self processRequest: request for: socket ]
    beforeUnwind: [ :ex | ^ self writeServerError: ex to: socket ]
    ensure: [ socket close ]
```

---

###Gem Server Transaction Management

####Basic Gem Server Transaction Support
The current implementation supports [manual transaction mode](#manual-transaction-mode) when running a *gem server* from a script using the `scriptStartServiceOn:` method.

For [interactive debugging](#interactive-debugging) using the `interactiveStartServiceOn:transactionMode:` method: 
  - [automatic transaction mode](#automatic-transaction-mode) (**#autoBegin**) can be used when doing *normal* development.
  - [manual transaction mode](#manual-transaction-mode) (**#manualBegin**) should be used when debugging or testing transaction sensitive code.

Regardless of which *transaction mode* is used, it is important to manage transaction boundaries very carefully:

>> When an abort or begin transaction is executed all un-committed changes to persistent objects are lost irrespective of which thread may have made the changes.

The **GemServer** class provides three methods for performing transactions: 
  - [`doBasicTransaction:`](#dobasictransaction)
  - [`doTransaction:onConflict:`](#dotransactiononconflict)
  - [`doTransaction:`](#dotransaction)

#####doBasicTransaction:
The `doBasicTransaction:` method performs transactions under the protection of the `transactionMutex`:

```Smalltalk
doBasicTransaction: aBlock
  "I do an unconditional commit. 
   If running in manual transaction mode, the system will be outside of transaction upon 
    returning.
   Return true, if the transaction completed without conflicts.
   If the transaction fails, return false and the caller is responsible for post commit failure
   processing."

  self transactionMutex
    critical: [ 
      | commitResult |
      [ 
      System inTransaction
        ifTrue: [ aBlock value ]
        ifFalse: [ 
          self doBeginTransaction.
          aBlock value ] ]
        ensure: [ 
          "workaround for Bug 42963: ensure: block executed twice (don't return from ensure: block)"
          commitResult := self doCommitTransaction ].
      ^ commitResult ]
```

It is **absolutely** imperative that all manipulation of persistent data in the *gem server* be performed while in the critical section of the `transactionMutex`.
Otherwise it is not possible to guarantee the integrity of your persistent data.

The  `doBasicTransaction:` method does not handle commit failures, so for everyday transactions, you should use either [`doTransaction:onConflict:`](#dotransactiononconflict) or [`doTransaction:`](#dotransaction), depending upon whether or not you want to handle [commit conflicts](#transaction-conflict) explicitly or not.

#####doTransaction:onConflict:
The `doTransaction:onConflict:` method allows you to specify action to be taken in the event of a [commit conflict](#transaction-conflict):

```Smalltalk
doTransaction: aBlock onConflict: conflictBlock
  "Perform a transaction. If the transaction fails, evaluate <conflictBlock> with transaction 
   conflicts dictionary."

  (self doBasicTransaction: aBlock)
    ifFalse: [ 
      | conflicts |
      conflicts := System transactionConflicts.
      self doAbortTransaction.
      conflictBlock value: conflicts ]
```

The `conflictBlock` is passed the [conflict dictionary](#transaction-conflict-dictionary) as an argument.
Typically the `conflictBlock` is used to stash the [conflict dictionary](#transaction-conflict-dictionary) in the [object log](#object-log).

#####doTransaction:
If an error is the appropriate response to a [commit conflict](#transaction-conflict), then the `doTransaction` method should be used: 

```Smalltalk
doTransaction: aBlock
  "Perform a transaction. If the transaction fails, signal an Error."

  self
    doTransaction: aBlock
    onConflict: [ :conflicts | 
      (self
        doBasicTransaction: [ ObjectLogEntry warn: 'Commit failure ' object: conflicts ])
        ifTrue: [ self error: 'commit conflicts' ]
        ifFalse: [ 
          self doAbortTransaction.
          self error: 'commit conflicts - could not log conflict dictionary' ] ]
```

This method dumps the  [conflict dictionary](#transaction-conflict-dictionary) to the [object log](#object-log) and signals an error.

####Practical Gem Server Transaction Support
The `gemServerTransaction:exceptionSet:beforeUnwind:ensure:onConflict:` wraps a transaction around the [`gemServer:exceptionSet:beforeUnwind:ensure:`](#gem-server-exception-handling) method and exports the [`conflictBlock`](#dotransactiononconflict):

```Smalltalk
gemServerTransaction: aBlock exceptionSet: exceptionSet beforeUnwind: beforeUnwindBlock ensure: ensureBlock onConflict: conflictBlock
  (System inTransaction and: [ self transactionMode ~~ #'autoBegin' ])
    ifTrue: [ 
      self
        error:
          'Expected to be outside of transaction. Use doAbortTransaction or doCommitTransaction before calling.' ].
  self
    doTransaction: [ 
      ^ self
        gemServer: aBlock
        exceptionSet: exceptionSet
        beforeUnwind: beforeUnwindBlock
        ensure: ensureBlock ]
    onConflict: conflictBlock
```

There are several variants of the  `gemServerTransaction:exceptionSet:beforeUnwind:ensure:onConflict:` available:
  - gemServerTransaction:
  - gemServerTransaction:beforeUnwind:
  - gemServerTransaction:beforeUnwind:ensure:
  - gemServerTransaction:beforeUnwind:ensure:onConflict:
  - gemServerTransaction:beforeUnwind:onConflict:
  - gemServerTransaction:ensure:
  - gemServerTransaction:ensure:onConflict:
  - gemServerTransaction:exceptionSet:
  - gemServerTransaction:exceptionSet:beforeUnwind:
  - gemServerTransaction:exceptionSet:beforeUnwind:ensure:
  - gemServerTransaction:exceptionSet:beforeUnwind:ensure:onConflict:
  - gemServerTransaction:exceptionSet:beforeUnwind:onConflict:
  - gemServerTransaction:exceptionSet:beforeUnwind:onConflict:ensure:
  - gemServerTransaction:exceptionSet:ensure:
  - gemServerTransaction:onConflict:

With only one Smalltalk process in the *transaction critical section* at any one time, you must run **N** separate *gem server* to handle **N** concurrent tasks.
The shorter you can make the task response time, the fewer *gem servers* that you'll need.

Long running transactions combined with a large number of *gem servers* can lead to large a [commit record backlogs](#commit-record-backlog), so it is a good idea to make your transactions as short as possible.

In general there are two broad categories of tasks performed by a *gem server*:
  - Quick hitting, compute intensive [request/response tasks](#requestresponse-gem-server-tasks).
  - Long running, wait intensive [I/O tasks](#io-gem-server-tasks).

#####Request/Response Gem Server Tasks
In a quick hitting, request/response *gem server* you should run the request handling logic in a forked process and wrap it with a `gemServerTransaction:*` call like the following:

```Smalltalk
handleRequest: request for: socket
  [ 
  self
    gemServerTransaction: [ ^self processRequest: request for: socket ]
    beforeUnwind: [ :ex | ^ self writeServerError: ex to: socket ]
    ensure: [ socket close ] ] fork
```

In this example I assume that the `processRequest:for:` is pure business logic and will execute relatively quickly.

By following this pattern, you will be able to write the `processRequest:for:` logic without ever having to worry about transaction boundaries.

This is basically the transaction model used by [GsDevKit/Seaside31][4].

#####I/O Gem Server Tasks
In a long running, wait intensive *gem server*, you will run the task handling logic in a forked process, as before, but you will want to exclude the wait intensive tasks, from the *transaction critical block*, like the following:

```Smalltalk
performTask:
  [ 
  self
    gemServer: [ | response |
      response := (HTTPSocket httpGet: 'http://example.com') contents.
      self gemServerTransaction: [ self processResponse: response ] ] ] fork
```

In this example we do the http get *outside of transaction*, which means that a large number of tasks can be waiting for an http response, concurrently.
Only when a response becomes available, does the *transaction mutex* and then the processing required while *in transaction* should be very short.

It is important that one avoids modifying persistent objects while *outside of transaction*.
It is permissable to read persistent objects but any modifications to persistent objects made while outside of transaction will be lost when the [abort](#abort-transaction) or [begin](#begin-transaction) transaction is called by the `gemServerTransaction:` method.

---

###Gem Server Control

When you register a *gem server*, you specify a list of ports associated with the *gem server*:

```Smalltalk
FastCGISeasideGemServer register: 'Seaside' on: #( 9001 9002 9003 )
```

When you subsequently ask the *gem server* to start:

```Smalltalk
(GemServerRegistry gemServerNamed: 'Seaside') startGems.
```

A [Topaz][2] process should be started for each port in the list.

The `startGems` method:

```Smalltalk
startGems
  self initCrashLog.
  System commitTransaction
    ifFalse: [ self error: 'Commit transaction failed before startGems' ].
  self logControlEvent: 'Start Gems: ' , self name.
  self ports
    do: [ :port | 
      | pidFilePath |
      pidFilePath := self gemPidFileName: port.
      (GsFile existsOnServer: pidFilePath)
        ifTrue: [ 
          self
            error:
              'Pid file exists for port: ' , port printString , '. Try restart command.' ].
      self executeStartGemCommand: port ]
```

calls the `executeStartGemCommand:` method, which in turn constructs shell command line that calls the [*gem server* start script](#gem-server-start-script):

```Smalltalk
executeStartGemCommand: port
  | commandLine |
  commandLine := self startScriptPath , ' ' , self name , ' ' , port asString
    , ' "' , self exeConfPath , '"'.
  self performOnServer: commandLine
```

####Gem Server Control from Smalltalk
*Gem servers* can be started, stopped and restarted from Smalltalk:

```Smalltalk
(GemServerRegistry gemServerNamed: 'Seaside') startGems.
(GemServerRegistry gemServerNamed: 'Seaside') stopGems.
(GemServerRegistry gemServerNamed: 'Seaside') restartGems.
```

####Gem Server Bash scripts
The *gem server* bash scripts are designed to control a single *gem server* operating system process, one process for each port in the port.
The bash scripts are aimed at making it possible to start and stop individual gem servers from a process management tool like [DaemonTools][5] or [Monit][6].

The scripts are also called from within Smalltalk using `System class>>performOnServer:`.

#####Gem Server start script
The [*gem server* start script][14] takes three arguments:
  1. gem server name
  2. port number
  3. exe conf file path

```
startGemServerGem Seaside 9001 $GEMSTONE_EXE_CONF
```

The script itself invokes the following Smalltalk code:

```Smalltalk
(GemServerRegistry gemServerNamed: '<gemServerName>') scriptStartServiceOn: <portNumberOrNil>.
```

The `scriptStartServiceOn:` method:

```Smalltalk
scriptStartServiceOn: portOrNil
  "called from shell script"

  self
    scriptServicePrologOn: portOrNil;
    startServerOn: portOrNil	"does not return"
```

initiates the [service loop](#gem-server-service-loop) and calls the `scriptServicePrologOn:` method: 

```Smalltalk 
scriptServicePrologOn: portOrNil
  self
    scriptLogEvent:
      '-->>Script Start ' , self name , ' on ' , portOrNil printString
    object: self.
  self
    recordGemPid: portOrNil;
    setStatmonCacheName;
    enableRemoteBreakpointHandling.
  self transactionMode: #'manualBegin'.
  self
    startTransactionBacklogHandling;
    enableAlmostOutOfMemoryHandling
```

which among other things records the `gem process id` in a file, so that the [gem server stop script](#gem-server-stop-script) knows which operating system process to kill.

#####Gem Server stop script
The [*gem server* stop script][15] takes two arguments:
  1. gem server name
  2. port number

```
stopGemServerGem Seaside 9001
```

The script gets the `gem process id` from the `pid` file and kills.

---

###Gem Server Debugging
####Object Log Debugging
In normal operation, a *gem server* is running as a headless [Topaz][2] process.
When an error occurs, [a continuation is saved to the object log](#gem-server-exception-logging):

```
info        Start Gems: Seaside_Style_Example_Server               20685  01/05/2015 15:28:19:991
info        -->>Script Start Seaside_Style_Example_Server on 8...  21598  01/05/2015 15:28:20:084
info        performOnServer: Seaside_Style_Example_Server :: /...  20685  01/05/2015 15:28:20:093
info        recordGemPid: Seaside_Style_Example_Server on 8383     21598  01/05/2015 15:28:20:138
info        setStatmonCacheName: Seaside_Style_Example_Server      21598  01/05/2015 15:28:20:235
info        enableRemoteBreakpointHandling: Seaside_Style_Exam...  21598  01/05/2015 15:28:20:284
info        startTransactionBacklogHandling: Seaside_Style_Exa...  21598  01/05/2015 15:28:20:435
info        enable AlmostOutOfMemoryHandling: Seaside_Style_Ex...  21598  01/05/2015 15:28:20:485
error       -- continuation -- (Seaside_Style_Example_Server U...  21598  01/05/2015 15:28:20:537
```

In an interactive client, you can open a debugger on the continuation:

```
1. DebuggerLogEntry class>>createContinuationFor: @2 line 5
2. DebuggerLogEntry class>>createContinuationLabeled: @3 line 4
3. GemServerSeasideStyleExample class(GemServer class)>>createContinuation: @2 line 2
4. GemServerSeasideStyleExample(GemServer)>>createContinuation: @5 line 5
5. GemServerSeasideStyleExample(GemServer)>>saveContinuationFor:titled:inTransactionDo: @8 line 6
6. GemServerSeasideStyleExample(GemServer)>>logStack:titled:inTransactionDo: @3 line 4
7. GemServerSeasideStyleExample(GemServerRemoteAbstractExample)>>logStack:titled:inTransactionDo: @2 line 3
8. GemServerSeasideStyleExample(GemServer)>>logStack:titled: @2 line 2
9. GemServerSeasideStyleExample(GemServer)>>gemServerHandleErrorException: @9 line 6
10. UserDefinedError(Error)>>exceptionHandlingForGemServer: @2 line 2
11. GemServerSeasideStyleExample(GemServer)>>handleGemServerException: @2 line 5
12. [] in GemServerSeasideStyleExample(GemServer)>>gemServer:exceptionSet:beforeUnwind:ensure: @3 line 10
13. GemServerSeasideStyleExample(ExecBlock)>>on:do: @3 line 42
14. [] in GemServerSeasideStyleExample(GemServer)>>gemServer:exceptionSet:beforeUnwind:ensure: @2 line 12
15. UserDefinedError(AbstractException)>>_executeHandler: @3 line 8
16. UserDefinedError(AbstractException)>>_signalWith: @1 line 1
17. UserDefinedError(AbstractException)>>signal @2 line 47
18. GemServerSeasideStyleExampleRequest(Object)>>error: @6 line 7
19. GemServerSeasideStyleExampleRequest>>requestError @2 line 2
20. [] in ExecBlock(GemServerSeasideStyleExampleTests)>>testSeasideStyleError @2 line 9
21. GemServerSeasideStyleExampleRequest>>processRequest @3 line 2
22. GemServerSeasideStyleExample>>processRequest: @2 line 2
23. [] in GemServerSeasideStyleExample>>processRequest:onSuccess:onError: @2 line 7
24. GemServerSeasideStyleExample(ExecBlock)>>on:do: @3 line 42
25. [] in GemServerSeasideStyleExample(GemServer)>>gemServer:exceptionSet:beforeUnwind:ensure: @2 line 4
26. GemServerSeasideStyleExample(ExecBlock)>>ensure: @2 line 12
27. GemServerSeasideStyleExample(GemServer)>>gemServer:exceptionSet:beforeUnwind:ensure: @2 line 23
28. [] in GemServerSeasideStyleExample(GemServer)>>gemServerTransaction:exceptionSet:beforeUnwind:ensure:onConflict: @2 line 10
29. [] in GemServerSeasideStyleExample(GemServer)>>doBasicTransaction: @7 line 17
30. GemServerSeasideStyleExample(ExecBlock)>>ensure: @2 line 12
31. [] in GemServerSeasideStyleExample(GemServer)>>doBasicTransaction: @2 line 18
32. GemServerSeasideStyleExample(ExecBlock)>>ensure: @2 line 12
33. TransientRecursionLock>>critical: @11 line 12
34. GemServerSeasideStyleExample(GemServer)>>doBasicTransaction: @3 line 10
35. GemServerSeasideStyleExample(GemServer)>>doTransaction:onConflict: @2 line 5
36. GemServerSeasideStyleExample(GemServer)>>gemServerTransaction:exceptionSet:beforeUnwind:ensure:onConflict: @8 line 8
37. GemServerSeasideStyleExample(GemServer)>>gemServerTransaction:beforeUnwind:onConflict: @3 line 3
38. GemServerSeasideStyleExample>>processRequest:onSuccess:onError: @2 line 7
39. [] in GemServerSeasideStyleExample>>handleRequestFrom: @5 line 11
40. GemServerSeasideStyleExample(ExecBlock)>>on:do: @3 line 42
41. [] in GemServerSeasideStyleExample(GemServer)>>gemServer:exceptionSet:beforeUnwind:ensure: @2 line 4
42. GemServerSeasideStyleExample(ExecBlock)>>ensure: @2 line 12
43. GemServerSeasideStyleExample(GemServer)>>gemServer:exceptionSet:beforeUnwind:ensure: @2 line 23
44. GemServerSeasideStyleExample(GemServer)>>gemServer:beforeUnwind: @3 line 3
45. GemServerSeasideStyleExample>>handleRequestFrom: @2 line 5
46. [] in GemServerSeasideStyleExample>>basicServerOn: @2 line 13
47. GsProcess>>_start @7 line 16
48. UndefinedObject(GsNMethod class)>>_gsReturnToC @1 line 1
```

While you cannot resume execution of a stack from a *debugger continuation*, you can view the source of the methods on the stack and see the values of arguments and instance variables, which is often enough to characterize a problem.

If you are experiencing problems in production and are having trouble characterizing the problem, you can insert `halt` statements into your code.
By default the [*gem server* exception handlers](#gem-server-exception-set) will handle a **Halt** by saving a debug continuation to the [object log](#object-log) and then `resuming` the **Halt** exception, so execution continues.
Naturally there is a cost to saving continuations, but it continuation-based debugging is superior to print statment debugging.

####Interactive Debugging

If you have a reproducable test case or you need to do some hands on development of your server code, you would like to be able run a *gem server* in your favorite interactive development environment.
However, there are several obstacles that need to be overcome when trying to do interactive development with a *gem server* that has been designed to run in a headless [Topaz][2] session:
  1. The GemStone [GCI](#gembuilder-for-c) (used by interactive development environments for GemStone) permits only one non-blocking function call per session.
     This means that when a Smalltalk thread is active in a *gem server*, the interactive development environment may not make any other [GCI](#gembuilder-for-c) function calls.
     In effect the development environment must block until the in process non-blocking call returns.
  2. The *gem server* code is structured to [handle most of the interesting exceptions](#gem-server-exception-set) by [logging the stack to the object log and either unwinding the stack or resuming the exception](#gem-server-exception-handlers).
     This means that without *devine intervention*, an interactive debugger will not be opened when an interesting exception occurs.
  3. The *gem server* is [designed to run in manual transaction mode](#gem-server-transaction-management).
     This means that you need to explicitly manage transaction boundaries. 

The solution to having the server debugging session blocked while serving requests is to use with two interactive debugging sessions.
  1. Server debugging session which is blocked running the [*gem server* service loop](#gem-server-service-loop).
  2. Client debugging session, which is where most of the interactive development takes place.

In order to arrange to debug interesting exceptions, one may set `interactiveMode` for the *gem server*. 
When `interactiveMode` is `true`, the *gem server* passes exceptions to the debugger, instead of doing the [standard exception logging](#gem-server-exception-logging):

```Smalltalk
doInteractiveModePass: exception
  self interactiveMode
    ifTrue: [ exception pass ]
```

Finally, one may use [automatic transaction mode](#automatic-transaction-mode) when using `GemServer>>interactiveStartServiceOn:transactionMode:` to start the server:

```Smalltalk
interactiveStartServiceOn: portOrNil transactionMode: mode
  "called from development environment ... service run in current vm."

  "transactionMode: #autoBegin or #manualBegin"

  self
    scriptLogEvent:
      '-->>Interactive Start ' , self name , ' on ' , portOrNil printString
    object: self.
  self transactionMode: mode.
  mode == #'manualBegin'
    ifTrue: [ self startTransactionBacklogHandling ].
  self
    enableAlmostOutOfMemoryHandling;
    startServerOn: portOrNil	"does not return"
```

#####Interactive Debugging Example
For this example we will be using the **GemServerRemoteServerSerialProcessingExample** for the *gem server* and the **GemServerRemoteClientSerialProcessingExample** as the client.  

The **GemServerRemoteServerSerialProcessingExample** instance takes tasks (**GemServerRemoteTaskSerialProcessingExample** class) off of a queue and executes the task in a separate Smalltalk process. 
If the task completes successfully the result is stored as the `value` for the task which marks the task as complete. 
If an error occurs while executing the task, the resulting exception is stored as the `exception` for the task which marks the task as complete.

The **GemServerRemoteClientSerialProcessingExample** instance adds requested tasks to the queue and then waits for the list of tasks to finish processing by the server.

1. Open two interactive development clients, one will be designated as the **client session** and the other will be designated as the **server session**
2. In the **client session** register the *gem server*:
   ```Smalltalk
   (GemServerRemoteServerSerialProcessingExample register: 'example')
     interactiveMode: true.
   ```

3. In the **server session**...
     

---
---

##Glossary

###Abort Transcation
**Excerpted from [Programming Guide for GemStone/S 64 Bit][3], Section 8.2**

---

*Aborting a transaction discards any changes you have made to shared objects during the
transaction. However, work you have done within your own object space is not affected
by an abortTransaction. GemStone gives you a new view of the repository that does
not include any changes you made to permanent objects during the aborted
transaction—because the transaction was aborted, your changes did not affect objects in
the repository. The new view, however, does include changes committed by other users
since your last transaction started. Objects that you have created in the GemBuilder for
Smalltalk object space, outside the repository, remain until you remove them or end your
session.*

---

###Automatic transaction mode
**Excerpted from [Programming Guide for GemStone/S 64 Bit][3], Section 8.1**

---

*In this mode, GemStone begins a transaction when you log in, and starts a new one after
each commit or abort message. In this default mode, you are in a transaction the entire
time you are logged into a GemStone session. Use caution with this mode in busy
production systems, since your session will not receive the signals that your view is
causing a strain on system resources.*

*This is the default transaction mode on login.*

*To change to transactionless transaction mode, send the message:*

*`System transactionMode: #autoBegin`*

*This aborts the current transaction and starts a new transaction.*

---

###Begin Transaction
**Excerpted from [Programming Guide for GemStone/S 64 Bit][3], Section 8.2**

---
*To begin a transaction, execute*

*System beginTransaction*

*This message gives you a fresh view of the repository and starts a transaction. When you
commit or abort this new transaction, you will again be outside of a transaction until you
either explicitly begin a new one or change transaction modes.*

---

###Commit Record Backlog
**Excerpted from [System Administration Guide for GemStone/S 64 Bit][7], Section 4.9**

---

*Sessions only update their view of the repository when they commit or abort. The repository must keep a copy of each session’s view so long as the session is using it, even if other sessions frequently commit changes and create new views (commit records). Storing the original view and all the intermediate views uses up space in the repository, and can result in the repository running out of space. To avoid this problem, all sessions in a busy system should commit or abort regularly.*

*For a session that is not in a transaction, if the number of commit records exceeds the
value of STN_CR_BACKLOG_THRESHOLD, the Stone repository monitor signals the session to abort by signaling TransactionBacklog (also called “sigAbort”). If the session does not abort, the Stone repository monitor reinitializes the session or terminates it, depending on the value of STN_GEM_LOSTOT_TIMEOUT.*

*Sessions that are in transaction are not subject to losing their view forcibly. Sessions in
transaction enable receipt of the signal TransactionBacklog, and handle it appropriately, but it is optional. It is important that sessions do not stay in transaction for long periods in busy systems; this can result in the Stone running out of space and shutting down. However, sessions that run in automatic transaction mode are always in transaction; as soon as they commit or abort, they begin a new transaction. (For a discussion of automatic and manual transaction modes, see the “Transactions and Concurrency Control” chapter of the GemStone/S 64 Bit Programming Guide.) *

---

###Commit Transaction
**Excerpted from [Programming Guide for GemStone/S 64 Bit][3], Section 8.2**

---

*Committing a transaction has two effects:*
- *It makes your new and changed objects visible to other users as a permanent part of
the repository.*
- *It makes visible to you any new or modified objects that have been committed by
other users in an up-to-date view of the repository.*

---

###GemBuilder for C

**Excerpted from [GemBuilder for C
for GemStone/S 64 Bit][3], Section 1**

---
*GemBuilder for C is a set of C functions that
provide your C application with complete
access to a GemStone repository and its pr
ogramming language, GemS
tone Smalltalk. The
GemStone object server contains your schema
(class definitions) and
objects (instances of
those classes), while your C
program provides the user in
terface for your GemStone
application. The GemBuilder functions allo
w your C program to access the GemStone
repository either through structural access (the C model) or by sending messages (the
Smalltalk model).*

---

###GemStone Session
**Excerpted from [Topaz Programming Environment for GemStone/S 64 Bit][2], Section 1.2**

---

*A GemStone session consists of four parts:*
- *An application, such as, [Topaz][2].*
- *One repository. An application has one repository to hold its persistent objects.*
- *One repository monitor, or Stone process, to control access to the repository.*
- *At least one GemStone session, or Gem process. All applications, including [Topaz][2],
  must communicate with the repository through Gem processes. A Gem provides a
  work area within which objects can be used and modified. Several Gem processes can
  coexist, communicating with the repository through a single Stone process...*

---

###GemStone Transaction
**Excerpted from [Programming Guide for GemStone/S 64 Bit][3], Section 8.1**

---

*GemStone prevents conflict between users by encapsulating each session’s operations
(computations, stores, and fetches) in units called transactions. The operations that make
up a transaction act on what appears to you to be a private view of GemStone objects.
When you tell GemStone to commit the current transaction, GemStone tries to merge the
modified objects in your view with the shared object store.*

#### *Views and Transactions*

*Every user session maintains its own consistent view of the
repository state. Objects that the repository contained at the beginning of your session are
preserved in your view, even if you are not using them—and even if other users’ actions
have rendered them obsolete. The storage that those objects are using cannot be reclaimed
until you commit or abort your transaction. Depending upon the characteristics of your
particular installation (such as the number of users and the commit frequency), this
burden can be trivial or significant.
When you log in to GemStone, you get a view of repository state. After login, you may
start a transaction automatically or manually, or remain outside of transaction. The
repository view you get on login is updated when you begin a transaction or abort. When
you commit a transaction, your changes are merged with other changes to the shared data
in the repository, and your view is updated. When you obtain a new view of the
repository, by commit, abort, or continuing, any new or modified objects that have been
committed by other users become visible to you...*

---

###GEM_MAX_SMALLTALK_STACK_DEPTH
**Excerpted from [System Administration Guide for GemStone/S 64 Bit][7], Appendix A.3**

---

*GEM_MAX_SMALLTALK_STACK_DEPTH determines the size of the GemStone Smalltalk
execution stack space that is allocated when the Gem logs in. The unit is the approximate
number of method activations in the stack. This setting causes heap memory allocation of
approximately 64 bytes per activation. Exceeding the stack depth results in generation of
the error RT_ERR_STACK_LIMIT.*

*Min: 100*

*Max: 1000000*

*Default: 1000*

---

###Manual Transaction Mode
**Excerpted from [Programming Guide for GemStone/S 64 Bit][3], Section 8.1**

---

*In this mode, you can be logged in and outside of a transaction. You explicitly control whether your session starts a transaction, makes changes, and commits. Although a transaction is started for you when you log in, you can set the transaction mode to manual, which aborts the current transaction and leaves you outside a transaction. You can subsequently start a transaction when you are ready to commit. Manual transaction mode provides a method of minimizing the transactions, while still managing the repository for concurrent access.*

*In manual transaction mode, you can view the repository, browse objects, and make computations based upon object values. You cannot, however, make your changes permanent, nor can you add any new objects you may have created while outside a transaction. You can start a transaction at any time during a session; you can carry temporary results that you may have computed while outside a transaction into your new transaction, where they can be committed, subject to the usual constraints of conflict-checking.*

*To change to manual transaction mode, send the message:*

*System transactionMode: #manualBegin*

*This aborts the current transaction and leaves the session not in transaction.*

*To begin a transaction, execute*

*System beginTransaction*

*This message gives you a fresh view of the repository and starts a transaction. When you
commit or abort this new transaction, you will again be outside of a transaction until you
either explicitly begin a new one or change transaction modes.*

---

###Maintenance VM
The *maintenance vm* is a gem server that must be run while serving Seaside requests.
The main job of the *maintenance vm* is to reap expired session state.
The *maintenance vm* also runs an hourly *mark For collect*.
For large Seaside installations (a stone where the entire GemStone repository cannot fit into the Shared Page Cache), the *mark for collect* should be moved into a separate gem server and run during off-peak hours.

###Object Log
The *object log* is a persistent, reduced conflict collection of **ObjectLogEntry** instances.
An **ObjectLogEntry** records the following information:
  - *pid* of the gem in which the instance is created
  - instance creation time stamp
  - user-defined label
  - priority (debug, error, fatal, info, interaction, trace, or transcript)
  - user-defined object
  - user-defined tag

One can add arbitrary labeled  objects to the *object log*, so it can function as a very sophisticated form of *print statement debugging*.


###Temporary Object Space
**Excerpted from [Programming Guide for GemStone/S 64 Bit][3], Section 14.3**

---

*The temporary object space cache is used to store temporary objects created by your
application. Each Gem session has a temporary object memory that is private to the Gem
process and its corresponding session. When you fault persistent (committed) objects into
your application, they are copied to temporary object memory.*

*Some of these objects may ultimately become permanent and reside on the disk, but
probably not all of them. Temporary objects that your application creates merely in order
to do its work reside in temporary object space until they are no longer needed, when the
Gem’s garbage collector reclaims the storage they use.*

*It is important to provide sufficient temporary object space. At the same time, you must
design your application so that it does not create an infinite amount of reachable
temporary objects. Temporary object memory must be large enough to accommodate the
sum of live temporary objects and modified persistent objects. It that sum exceeds the
allocated temporary object memory, the Gem can encounter an OutOfMemory condition
and terminate.*

---

###Transaction Conflict
**Excerpted from [Programming Guide for GemStone/S 64 Bit][3], Section 8.2**

---

*GemStone detects conflict by comparing your read and write sets with those of all other
transactions committed since your transaction began. The following conditions signal a
possible concurrency conflict:*
- *An object in your write set is also in the write set of another transaction—a write-write
conflict. Write-write conflicts can involve only a single object.*
- *An object in your write set is also in another session’s dependency list—a writedependency
conflict. An object belongs to a session’s dependency list if the session has
added, removed, or changed a dependency (index) for that object. For details about
how GemStone creates and manages indexes on collections, see Chapter 7, Indexes
and Querying.*

*If a write-write or write-dependency conflict is detected, then your transaction cannot
commit. This mode allows an occasional out-of-date entry to overwrite a more current
one. You can use object locks to enforce more stringent control if you can anticipate the
problem.*

---

###Transaction Conflict Dictionary
**From the comment of the method System class>>transactionConflicts**

---

*Returns a SymbolDictionary that contains an Association whose key is #commitResult and whose value is one of the following Symbols: #success, #failure, #retryFailure, #commitDisallowed, or #rcFailure .*

*The remaining Associations in the dictionary are used to report the conflicts found.  Each Association's key indicates the kind of conflict detected; its associated value is an Array of OOPs for the objects that are conflicting. If there are no conflicts for the transaction, the returned SymbolDictionary has no additional Associations.*

*The conflict sets are cleared at the beginning of a commit or abort and therefore may be examined until the next commit, continue or abort.*

 *The keys for the conflicts are as follows:*

|Key|Conflicts|
|---|---------|
|Read-Write|StrongReadSet and WriteSetUnion conflicts.|
|Write-Write|WriteSet and WriteSetUnion conflicts.|
|Write-Dependency|WriteSet and DependencyChangeSetUnion conflicts.|
|Write-WriteLock|WriteSet and WriteLockSet conflicts.|
|Write-ReadLock|WriteSet and ReadLockSet conflicts.|
|Rc-Write-Write|Logical write-write conflict on reduced conflict object.|
|WriteWrite_minusRcReadSet|(WriteSet and WriteSetUnion conflicts) - RcReadSet)|

*The Read-Write conflict set has already had RcReadSet subtracted from it. The Write-Write conflict set does not have RcReadSet subtracted .*

*The Write-Dependency conflict set contains objects modified (including DependencyMap operations) in the current transaction that were either added to, removed from,  or changed in the DependencyMap by another transaction. Objects in the  Write-Dependency conflict set may be in the Write-Write conflict set.*

---

[1]: https://gemstonesoup.wordpress.com/2007/05/10/porting-application-specific-seaside-threads-to-gemstone/
[2]: http://downloads.gemtalksystems.com/docs/GemStone64/3.2.x/GS64-Topaz-3.2.pdf
[3]: http://downloads.gemtalksystems.com/docs/GemStone64/3.2.x/GS64-ProgGuide-3.2.pdf
[4]: https://github.com/GsDevKit/Seaside31#seaside31
[5]: https://github.com/Monty/GemStone_daemontools_setup#daemontools-setup-scripts-for-gemstones-on-ubuntu-or-other-debian-systems
[6]: http://mmonit.com/monit/
[7]: http://downloads.gemtalksystems.com/docs/GemStone64/3.2.x/GS64-SysAdminGuide-3.2.pdf
[8]: http://gemtalksystems.com/products/gs64/versions24x/
[9]: http://c2.com/cgi/wiki?DoubleDispatch
[10]: https://github.com/GsDevKit/ServiceVM#servicevm
[11]: https://github.com/GsDevKit/zinc
[12]: http://pharo.org/
[13]: http://pharo.org/web/files/screenshots/debugger.png
[14]: https://github.com/GsDevKit/gsApplicationTools/blob/master/bin/startGemServerGem
[15]: https://github.com/GsDevKit/gsApplicationTools/blob/master/bin/stopGemServerGem
[16]: http://downloads.gemtalksystems.com/docs/GemStone64/3.2.x/GS64-GemBuilderforC-3.2.pdf
