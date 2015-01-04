# Getting started with Gem Servers

##Table of Contents
- [What is a Gem Server](#what-is-a-gem-server)
  - [Topaz](#topaz)
    - [Topaz Execution Environment](#topaz-execution-environment)
      - [Exceptions to Handle in Topaz](#exceptions-to-handle-in-topaz)
    - [Topaz Transaction Modes](#topaz-transaction-modes)
- [GemServer class](#gemserver-class)
  - [Gem Server Service Loop](#gem-server-service-loop)
  - [Gem Server Exception Handling](#gem-server-exception-handling)
    - [Gem Server Default Exception Set](#gem-server-default-exception-set)
    - [Gem Server Default Exception Handlers](#gem-server-default-exception-handlers)
    - [Gem Server `beforeUnwindBlock`](#gem-server-beforeunwindblock)
    - [Gem Server Default Exception Logging](#gem-server-default-exception-logging)
  - [Gem Server Transaction Management](#gem-server-transaction-management)
    - [Which transaction mode for Topaz servers?](#which-transaction-mode-for-topaz-servers)
    - [Parallel Processing Mode](#parallel-processing-mode)
    - [Serial Processing Mode](#serial-processing-mode)
    - [Handling Transaction Conflicts](#handling-transaction-conflicts)
  - [Gem Server Control](#gem-server-control)
    - [Gem Server start/stop bash scripts](#gem-server-startstop-bash-scripts)
    - [Gem Server start/stip Smalltalk API](#gem-server-startstoprestart-smalltalk-api)
- [Basic Gem Server Structure](#basic-gem-server-structure)
- [Seaside Gem Servers](#seaside-gem-servers)
- [ServiceVM Gem Servers](#servicevm-gem-servers)
- [Non-Seaside Gem Servers](#non-seaside-gem-servers)
- [Background Articles](#background-articles)
- [Glossary](#glossary)

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

####Topaz Execution Environment

For server-style code to be run in [Topaz][2] you need to do two things:
  1. Ensure that the main Smalltalk process blocks and does not return.
  2. Ensure that all exceptions are handled, including exceptions signalled in processes that have been forked from the main Smalltalk process.

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

##GemServer class
As the preceding sections have highlighted there are several issues in the area of *server exception handling* and *server transaction management* that are unique to the GemStone Smalltalk environment.


The **GemServer** class provides a framework for standardized:
  - [exception handling services](#gem-server-exception-handlers)
  - [transaction management](#gem-server-transaction-management)

*Gem servers* have been defined for:
  - [Seaside][4] web servers
  - [Zinc][11] web servers
  - [Zinc][11] WebSocket servers
  - [Zinc][11] REST servers
  - [GsDevKit ServiceVm][10] servers



The [Topaz][2] process that runs the *application-specific service loop* is initiated by launching a [bash script](#gem-server-startstop-bash-scripts).


When you execute a Smalltalk expression in [Topaz][2] like the following:

```
run
(GemServerRegistry gemServerNamed: 'example') scriptStartServiceOn: 8383.
%
```

control does not return until the Smalltalk expression itself returns or an *unhandled exception* is signalled.
For *gem servers*, we insert the method `GemServer>>startServerOn:` in the call stack and it is blocked by an infinite **Delay** loop:

```Smalltalk
startServerOn: portOrNil
  "start server in current vm. Not expected to return."

  self startBasicServerOn: portOrNil.
  [ true ] whileTrue: [ (Delay forSeconds: 10) wait ]
```

While the infinite loop  guarantees that the main process will not return normally, we must still take *unhandled exceptions* into consideration.
It is important to note that *unhandled exceptions* in processes forked from the main process must also be taken into consideration.
For example the following [Topaz][2] will return control with an **Error** after 10 seconds:

```
run
[ (Delay forSeconds: 10) wait. 1 foo] fork.
[true] whileTrue: [ (Delay forSeconds: 1) wait ].
%
```

###Gem Server Service Loop
The `basicServerOn:` method implements the application-specific service loop and is expected to be defined by **GemServer** subclasses.

Here is the `basicServerOn:` method for a [maintenance vm](#maintenance-vm):

```Smalltalk
basicServerOn: portOrNil
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

The *service loop* is defined by subclassing the **GemServer** class and implementing a `basicServerOn:` method. 



###Gem Server Exception Handling

Here's the implementation of the `GemServer>>gemServer:exceptionSet:beforeUnwind:ensure:` method:

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
  1. The `exceptionSet` argument allows you to specify the set of [exceptions to be handled](#gem-server-default-exception-set).
  2. The `GemServer>>handleGemServerException:` method invokes [a custom exception handling method](#gem-server-default-exception-handlers).
  3. If the `GemServer>>handleGemServerException:` method returns, the [`beforeUnwindBlock`](#gem-server-beforunwindblock) is invoked.
  4. If the [`beforeUnwindBlock`](#gem-server-beforunwindblock) returns...
  5. `GemServer>>doInteractiveModePass:`
  6. Handler blocks falls off end and the stack is unwound.
  7. If an error occures while processing steps 3 and 4, ...
  8. `ensureBlock`.... 
     Typically the `ensure:` block is used to clean up any resources that may have been alocated for processing, such as sockets or files.


####Gem Server Default Exception Set
Default exception handling has been defined for the following exceptions (the list of default exceptions is slightly different for [GemStone 2.4.x][8]):
  - **Error**
  - **Break**
  - **Breakpoint**
  - **Halt**
  - **AlmostOutOfMemory**
  - **AlmostOutOfStack** 

####Gem Server Default Exception Handlers
The *gem server* uses [double dispatching][9] to invoke exception-specific handling behavior.
The primary method `exceptionHandlingForGemServer:` is sent by the `GemServer>>handleGemServerException:` method:

```Smalltalk
handleGemServerException: exception
  "if control is returned to receiver, then exception is treated like an error, i.e., 
   the beforeUnwindBlock is invoked and stack is unwound."

  ^ exception exceptionHandlingForGemServer: self
```

The `exceptionHandlingForGemServer:` has been implemented in the [default exception classes](#gem-server-default-exception-set).
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

where the [exception is logged](#gem-server-exception-logging) and the method returns.

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
The `beforeUnwindBlock` gives you a chance to 

####Gem Server Default Exception Logging

The __gemServer:*__ methods should be used at the very top of  each *forked* block in your *gem server*:


The __gemServer:*__ family of methods:  
  - gemServer:
  - gemServer:beforeUnwind:
  - gemServer:beforeUnwind:ensure:
  - gemServer:ensure:
  - gemServer:exceptionSet:
  - gemServer:exceptionSet:beforeUnwind:
  - gemServer:exceptionSet:beforeUnwind:ensure:
  - gemServer:exceptionSet:ensure:



The **gemServer:** method has


The **logStack:titled:** method:

```Smalltalk
logStack: exception titled: title inTransactionDo: inTransactionBlock
  self
    saveContinuationFor: exception
    titled: title
    inTransactionDo: inTransactionBlock.
  self writeGemLogEntryFor: exception titled: title
```

snaps off a continuation and saves it to the [object log](#object-log):

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

then dumps a stack trace to the gem log:

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


These messages are *double dispatched* via the `GemServer>>handleGemServerException:` method:

```Smalltalk
handleGemServerException: exception
  "if control is returned to receiver, then exception is treated like an error, i.e., 
   the beforeUnwindBlock is invoked and stack is unwound."

  ^ exception exceptionHandlingForGemServer: self
```

There are two options for handling exceptions in these methods: 
- *resume* the exception, in which case processing continues uninterrupted
- *return* from the method, in which case the stack is unwound to point of the **gemServer:** method call. 
  The **beforeUnwind:** block can be used to perform any additional actions that might need to be performed before unwinding the stack.

###Gem Server Transaction Management
####Which transaction mode for Topaz servers?
At first blush, [automatic transaction mode](#automatic-transaction-mode) seems to be the most convenient transaction mode for [Topaz][2] servers.
With the system always in transaction one should never get an error doing a [commit transaction](#commit-transaction) without a preceding [begin transaction](#begin-transaction).
However, if you are making use of multiple concurrent processes, there are advantages to using [manual transaction mode](#manual-transaction-mode).

[Manual transaction mode](#manual-transaction-mode) means that you have a bit more protection from incorrect [aborts](#abort-transaction) or [commits](#commit-transaction): 
  1. an incorrect [abort transaction](#abort-transaction) will result in a **commit error** before any logical corruption can be written to the repository.
  2. an inadvertant [commit transaction](#commit-transaction) will commit a partial result from another process to the repository, thus introducing potential logical corruption, but any subsequent commit will result in a **commit error**, so at least you will be alerted to the existence of the incorrect transaction semantics.

Using [automatic transaction mode](#automatic-transaction-mode) means that detecting logical corruption would be a bit harder to isolate and identify.

In a *gem server*, when an abort or begin transaction is executed all un-committed changes to persistent objects are lost irrespective of which thread may have made the changes.
The [view of the repository](#gemstone-transaction) is shared by all of the threads in the vm.
Consequently, one must take great care in managing transaction boundaries when running a multi-threaded application in a *gem server*.

These methods provide for *exception handling* and operate in [serial processing mode](#serial-processing-mode):
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

With the **onConflict:** block you may specify custom processing in the event of a [commit conflict](#transaction-conflict). 
By default, the [transaction conflict dictionary](#transaction-conflict-dictionary) is written to the [object log](#object-log).

The __gemServerTransaction:*__ methods should be used to wrap the code that does the work in your *gem server*:
 
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

####Parallel Processing Mode
In *parallel processing mode* multiple threads may be employed in a *gem server* where 
updates to persistent objects must be made within a critical section that:
  - acquires the *transaction mutex* (see `GemServer>>transactionMutex`)
  - performs an abort or begin transaction
  - updates the persistent objects
  - performs a commit

For convenience, the methods `GemServer>>doTransaction:` and `GemServer>>doTransaction:onConflict:` provide a safe way to update persistent objects in *parallel processing mode*:

```Smalltalk
doTransaction: aBlock onConflict: conflictBlock
  "Perform a transaction. If the transaction fails, evaluate <conflictBlock> with transaction 
   conflicts dictionary."

  (self doBasicTransaction: aBlock)
    ifFalse: [ 
      self doAbortTransaction.
      conflictBlock value: System transactionConflicts ]
```

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


####Serial Processing Mode
It may not always be practical or necessary to employ *parallel processing mode* in a *gem server*.
In [Seaside][4] applications, for example, transaction boundaries are defined to correspond to the HTTP request boundaries:
  1. begin transaction before handling the HTTP request
  2. commit transaction before returning HTTP response to the clent
  3. on conflict, abort transaction and retry HTTP request.
The transaction boundaries are managed by the Seaside framework and it is not necessary to complicate the application code with transaction management.

For concurrent processing, one may run multiple gems in parallel.


#####Seaside-style structure...

```Smalltalk
basicServerOn: ignored
  "forked by caller"

  self
    gemServer: [ 
      | requests |
      requests := self requests.
      [ requests notEmpty ]
        whileTrue: [ 
          | request |
          request := requests first.
          requests remove: request.
          [ self handleRequestFrom: request ] fork ] ]
```

```Smalltalk
handleRequestFrom: request
  "forked by caller"

  self
    gemServer: [ 
      | retryCount |
      retryCount := 0.
      [ retryCount < 11 ]
        whileTrue: [ 
          self
            processRequest: request
            onSuccess: [ :response | ^ self writeResponse: response to: request ]
            onError: [ :ex | ^ self writeApplicationError: ex to: request ].
          retryCount := retryCount + 1 ] ]
    beforeUnwind: [ :ex | ^ self writeServerError: ex to: request ]
```

```Smalltalk
processRequest: request onSuccess: successBlock onError: errorBlock
  "Both <successBlock> and errorBlock are expected to do a non-local return.
   If this method returns normally, the request should be retried. "

  | requestResult |
  requestResult := self
    gemServerTransaction: [ self processRequest: request ]
    beforeUnwind: errorBlock
    onConflict: [ :conflicts | 
      "log conflict and retry"
      self
        doTransaction: [ ObjectLogEntry error: 'Commit failure ' object: conflicts ].
      ^ self	"retry" ].
  successBlock value: requestResult
```


####Handling Transaction Conflicts
The default behavior for the **onConflict:** block is as follows:

```Smalltalk
gemServerTransaction: aBlock exceptionSet: exceptionSet beforeUnwind: beforeUnwindBlock
  self
    gemServerTransaction: aBlock
    exceptionSet: exceptionSet
    beforeUnwind: beforeUnwindBlock
    onConflict: [ :conflicts | 
      self doAbortTransaction.
      self
        doSimpleTransaction: [ ObjectLogEntry warn: 'Commit failure ' object: conflicts ] ]
```

The *conflicts* argument to the block is a [transaction conflict dictionary](#transaction-conflict-dictionary).
By default, the *transaction conflict dictionary* is written to the [object log](#object-log) for analysis.

For a web server, in addition to logging the *transaction conflict dictionary*, it may make sense to simply retry the request again, as is done for *Seaside*.

###Gem Server Control

####Gem Server start/stop bash scripts

####Gem Server start/stop/restart Smalltalk API

To define a GemServer you specify a name and a list of ports:

```Smalltalk
FastCGISeasideGemServer register: 'Seaside' on: #( 9001 9002 9003)
```

Once registered you can refer to the GemServer by name:

```Smalltalk
GemServerRegistry gemServerNamed: 'Seaside'
```

Gem servers can be started and stopped from within a development image using the Smalltalk GemServer api:

```Smalltalk
(GemServerRegistry gemServerNamed: 'Seaside') start.
(GemServerRegistry gemServerNamed: 'Seaside') restart.
(GemServerRegistry gemServerNamed: 'Seaside') stop.
```

or started and stopped by using a bash script:

```Shell
startGemServerGem Seaside 9001
stopGemServerGem Seaside 9001
```

The bash scripts are designed to be called once for each port associated with the gem server. 
This makes it possible to use scripts to start individual gem servers from a process management tool like [DaemonTools][5] or [Monit][6].

The Smalltalk GemServer api uses `System class>>performOnServer:` to launch a bash script for each of the ports associated with the gem server.

###Gem Server Logging
The exact logging options are a function of the application running in the service loop.
For example, Zinc-based gem servers offer a choice of Transcript logging (**logToTranscript**) or Object Log logging (**logToObjectLog**) with control over which events are logged (**#debug**, **#error**, **#info**, **#object**, and **#transaction**):

```Smalltalk
(ZnSeasideGemServer register: 'Seaside')
  logToObjectLog;
  logFilter: [:category | #( #error #debug ) includes: category ];
  yourself
```

###Debugging
####Remote Debugging
####Interactive Debugging
##Gem Server Reference
###Seaside Gem Servers (including ServiceVM)
###Zinc Gem Servers

**Eventually delete remainder of doc ... 


A **GemServer** class is used to define the application-specific service loop and any attributes that may be needed. 
For example, a web server must have a service loop that starts listening for http connections on a particular port, so the gem server attributes typically include a list of port numbers to launch servers on.
Other attributes may include the logging method and level to use.

##Basic Gem Server Structure

```Smalltalk
ZnGemServer register: 'RESTServer'.
FastCGISeasideGemServer register: 'FastCGISeasideServer' on: #( 9001 9002 9003 )
```

###Service Loop
####startServerOn:

```Smalltalk
startServerOn: port
  "start server in current vm. for gemstone, not expected to return."

  self startBasicServerOn: port.
  [ true ] whileTrue: [ (Delay forSeconds: 10) wait ]
```

####startBasicServerOn:

```Smalltalk
startBasicServerOn: port
  "start server in current vm. expected to return."

  [ "start listening on socket or running application specific service loop" ] fork.
```

```Smalltalk
startBasicServerOn: port
  "start instance of seaside adaptor. expected to return."

  | adaptor |
  GRPlatform current seasideLogServerStart: self class name port: port.
  adaptor := self serverClass port: port.
  self serverInstance: adaptor.
  adaptor gemServerStart
```


###Start/Restart/Stop/Status Gem Server

```Smalltalk
gemServer := FastCGISeasideGemServer register: 'FastCGISeasideServer' on: #( 9001 9002 9003 ).
gemServer startGems.
gemServer restartGems.
gemServer statusGems.
gemServer stopGems.
```

###Launching GemServer

```Smalltalk
scriptStartServiceOn: port
  "called from shell script"

  self
    scriptLogEvent: '-->>Start ' , self name , ' on ' , port printString
    object: self.
  self
    recordGemPid: port;
    setStatmonCacheName;
    enableRemoteBreakpointHandling.
  System transactionMode: #'manualBegin'.
  self
    startSigAbortHandling;
    startServiceOn: port	"does not return"
```

####Launching from bash shell

```Shell
startGemServerGem <gemServer-name> <port> <exe-conf-path>
```

```
#
# standard gem.conf file for dev kit gems
# 

GEM_TEMPOBJ_CACHE_SIZE = 50000;
GEM_TEMPOBJ_POMGEN_PRUNE_ON_VOTE = 90;
```

####Launching from development environment

```Smalltalk
gemServer startServerOn: 8383. "will not return"
```

## Seaside Gem Servers
In [Seaside][4] applications a *simple persistence model* is used where the [transaction](#gemstone-transaction) boundaries are aligned along HTTP request boundaries: 

1. An [abort](#abort-transaction) is performed before the HTTP request is passed to Seaside for processing.
2. A [commit](#commit-transaction) is performed before the HTTP request is returned to the HTTP client). 
3. [Transaction conflicts](#transaction-conflicts) are handled by doing an *abort* and then the HTTP request is retried.

###Seaside Adaptor Gem Server
###MaintenanceVM Gem Server
## ServiceVM Gem Servers
## Non-Seaside Gem Servers
###Zinc HTTP Gem Server
###Zinc REST Gem Server
###Zinc Web Socket Gem Server
##Background Articles
1. https://gemstonesoup.wordpress.com/2007/05/07/transparent-persistence-for-seaside/
2. https://gemstonesoup.wordpress.com/2008/03/08/glass-101-disposable-gems-durable-data/
3. https://gemstonesoup.wordpress.com/2008/03/09/glass-101-simple-persistence/
4. https://gemstonesoup.wordpress.com/2007/05/10/porting-application-specific-seaside-threads-to-gemstone/
5. https://gemstonesoup.wordpress.com/2007/06/29/unlimited-gemstone-vms-in-every-garage-and-a-stone-in-every-pot/
6. http://smalltalkinspect1.rssing.com/browser.php?indx=6463396&item=10

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

####Transaction State
**Excerpted from [Programming Guide for GemStone/S 64 Bit][3], Section 8.1**

---
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
