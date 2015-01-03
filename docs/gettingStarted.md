# Getting started with Gem Servers

##Table of Contents
- [What is a Gem Server](#what-is-a-gemserver)
  - [Gem Server Service Loop](#gem-server-service-loop)
  - [Gem Server Exception Handling](#gem-server-exception-handling)
  - [Gem Server Transaction Model](#gem-server-transaction-model)
    - [Parallel Processing Mode](#parallel-processing-mode)
    - [Serial Processing Mode](#serial-processing-mode)
    - [Handling Transaction Conflicts](#handling-transaction-conflicts)
- [Basic Gem Server Structure](#basic-gem-server-structure)
- [Seaside Gem Servers](#seaside-gem-servers)
- [ServiceVM Gem Servers](#servicevm-gem-servers)
- [Non-Seaside Gem Servers](#non-seaside-gem-servers)
- [Background Articles](#background-articles)
- [Glossary](#glossary)

##What is a Gem Server

A *gem server* is a [Topaz session](#gemstone-session) that executes an application-specific service loop.

###Gem Server Service Loop
The *service loop* is defined by subclassing the **GemServer** class and implementing a **basicServerOn:** method. 
Here is the **basicServerOn:** method for a [maintenance vm](#maintenance-vm):

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

This is a classic *forever* loop that performs a task every *delayTimeMs*.
The task itself is performed in a block that is passed into the **gemServer:** method. 

The **gemServer:** method is but one method in a family of methods that provide a standardardized set of *gem server* services.
The services can be divided into two broad categories: [exception handling](#gem-server-exception-handling) and [transaction management](#gem-server-transaction-model).

These methods provide the standard set of *exception handling* services and operate in [parallel processing mode](#parallel-processing-mode):  
  - gemServer:
  - gemServer:beforeUnwind:
  - gemServer:beforeUnwind:ensure:
  - gemServer:ensure:
  - gemServer:exceptionSet:
  - gemServer:exceptionSet:beforeUnwind:
  - gemServer:exceptionSet:beforeUnwind:ensure:
  - gemServer:exceptionSet:ensure:

With the **exceptionSet:** argument, you may specify a custom list of exceptions to be handled.

With the **beforeUnwind:** block, you may specify custom exception processing that is invoked after the exception-specific exception handling has run and before the stack is unwound.
For an HTTP server, this is the point in the stack where you would return a 5xx response.

With the **ensure:** block, you may specify an processing to be performed when the **gemServer:** call returns.
Typically the **ensure:** block is used to clean up any resources that may have been alocated for processing, such as sockets or files.

The __gemServer:*__ methods should be used at the very top of  each *forked* block in your *gem server*:

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
          unexpectedError return: nil	"unwind error stack" ].
      self doInteractiveModePass: exception.
      self	"unwind stack" ] ]
    ensure: ensureBlock
```

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

###Gem Server Exception Handling
The **gemServer:** method has default exception handlers for the following exceptions (the list of default exceptions is slightly different for [GemStone 2.4.x][8]):
  - **Error**
  - **Break**
  - **Breakpoint**
  - **Halt**
  - **AlmostOutOfMemory**
  - **AlmostOutOfStack** 

For example, when an **Error** exception is handled, the following method is invoked:

```Smalltalk
gemServerHandleErrorException: exception
  "log the stack trace and unwind stack, unless in interactive mode"

  self
    logStack: exception
    titled:
      self name , ' ' , exception class name asString , ' exception encountered: '.
```

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

Custom exception handlers are defined for each of the exceptions:
  - gemServerHandleAlmostOutOfMemoryException:
  - gemServerHandleAlmostOutOfStackException:
  - gemServerHandleBreakException:
  - gemServerHandleBreakpointException:
  - gemServerHandleErrorException:
  - gemServerHandleHaltException:
  - gemServerHandleNonResumableException:
  - gemServerHandleNotificationException:
  - gemServerHandleResumableException:

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

###Gem Server Transaction Model
In a *gem server*, when an abort or begin transaction is executed all un-committed changes to persistent objects are lost irrespective of which thread may have made the changes.
The [view of the repository](#gemstone-transaction) is shared by all of the threads in the vm.
Consequently, one must take great care in managing transaction boundaries when running a multi-threaded application in a *gem server*.

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

###Manual Transaction Mode
**Excerpted from [Programming Guide for GemStone/S 64 Bit][3], Section 8.1**

---

####*Manual transaction mode*

*In this mode, you can be logged in and outside of a transaction. You explicitly control whether your session starts a transaction, makes changes, and commits. Although a transaction is started for you when you log in, you can set the transaction mode to manual, which aborts the current transaction and leaves you outside a transaction. You can subsequently start a transaction when you are ready to commit. Manual transaction mode provides a method of minimizing the transactions, while still managing the repository for concurrent access.*

*In manual transaction mode, you can view the repository, browse objects, and make computations based upon object values. You cannot, however, make your changes permanent, nor can you add any new objects you may have created while outside a transaction. You can start a transaction at any time during a session; you can carry temporary results that you may have computed while outside a transaction into your new transaction, where they can be committed, subject to the usual constraints of conflict-checking.*

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
