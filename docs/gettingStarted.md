# Getting started with Gem Servers

##Table of Contents
- [What is a Gem Server](#what-is-a-gemserver)
- [Basic Gem Server Structure](#basic-gem-server-structure)
- [Seaside Gem Servers](#seaside-gem-servers)
- [ServiceVM Gem Servers](#servicevm-gem-servers)
- [Non-Seaside Gem Servers](#non-seaside-gem-servers)
- [Background Articles](#background-articles)
- [Glossary](#glossary)

##What is a Gem Server

A *gem server* is a [Topaz session](#gemstone-session) that executes an application-specific service loop.

###Gem Server Service Loop
The *service loop* is defined by subclassing the **GemServer** class and implementing a **startBasicServerOn:** method. 
Here is the **startBasicServerOn:** method for a [maintenance vm](#maintenance-vm):

```Smalltalk
startBasicServerOn: ignored
  "start server in current vm. expected to return."

  self
    maintenanceProcess:
      [ 
      | count |
      count := 0.
      [ true ]
        whileTrue: [ 
          [ 
          "run maintenance tasks"
          self taskClass performTasks: count.
          (Delay forMilliseconds: self delayTimeMs) wait.
          count := count + 1 ]
            on: self class breakpointExceptionSet
            do: [ :ex | self handleBreakpointException: ex ] ] ]
        fork.
  self serverInstance: self
```

As you can see, this is a classic *forever* loop that performs tasks every *delayTimeMs*. 
If an exception occurs (**Error**, **Halt**, or **Breakpoint**), the exception is handled by snapping off a continuation and resuming the exception (if possible):

```Smalltalk
handleBreakpointException: exception
  "Snap off continuation, then resume if possible"

  GRPlatform current
    doTransaction: [ DebuggerLogEntry createContinuationLabeled: exception description ].
  exception isResumable
    ifTrue: [ exception resume ]
    ifFalse: [ exception pass ]
```

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

###Maintenance VM
The *maintenance vm* is a gem server that must be run while serving Seaside requests.
The main job of the *maintenance vm* is to reap expired session state.
The *maintenance vm* also runs an hourly *mark For collect*.
For large Seaside installations (a stone where the entire GemStone repository cannot fit into the Shared Page Cache), the *mark for collect* should be moved into a separate gem server and run during off-peak hours.

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

[1]: https://gemstonesoup.wordpress.com/2007/05/10/porting-application-specific-seaside-threads-to-gemstone/
[2]: http://downloads.gemtalksystems.com/docs/GemStone64/3.2.x/GS64-Topaz-3.2.pdf
[3]: http://downloads.gemtalksystems.com/docs/GemStone64/3.2.x/GS64-ProgGuide-3.2.pdf
[4]: https://github.com/GsDevKit/Seaside31#seaside31
[5]: https://github.com/Monty/GemStone_daemontools_setup#daemontools-setup-scripts-for-gemstones-on-ubuntu-or-other-debian-systems
[6]: http://mmonit.com/monit/
