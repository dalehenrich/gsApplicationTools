# Getting started with Gem Servers

The gsApplicationTools project provides a framework for launching gem servers.

A *gem server* is a [Topaz session](#gemstone-session) that executes an application-specific service loop.

GsDevKit [Seaside][4] applications use a [simple persistence model][5] where the [transaction](#gemstone-transaction) boundaries are aligned along HTTP request boundaries where an [abort](#abort-transaction) is performed before the HTTP request is passed to Seaside for processing and a [commit](#commit-transaction) is performed before the HTTP request is returned to the HTTP client). [Transaction conflicts](#transaction-conflicts) are handled by simply doing an *abort* and then retrying the HTTP request.




Since only one *transaction* may be active at any one time within a *GemStone session*, multiple *gem servers* must be run to achieve concurrent execution.

therefore it to is necessry to run multiple 

a separate operating system process ([topaz][2]) that runs a single GemStone session.
Application-specific gem servers are needed for GsDevKit because [it is not a good idea to fork application-specific threads within a Seaside application][1].
Multiple gems


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

*Committing a transaction has two effects:
- It makes your new and changed objects visible to other users as a permanent part of
the repository.
- It makes visible to you any new or modified objects that have been committed by
other users in an up-to-date view of the repository.*

---

###GemStone Session
**Excerpted from [Topaz Programming Environment for GemStone/S 64 Bit][2], Section 1.2**

---

*A GemStone session consists of four parts:
- An application, such as, [Topaz][2].
- One repository. An application has one repository to hold its persistent objects.
- One repository monitor, or Stone process, to control access to the repository.
- At least one GemStone session, or Gem process. All applications, including [Topaz][2],
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
modified objects in your view with the shared object store. 

#### Views and Transactions

Every user session maintains its own consistent view of the
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

###Transaction Conflict
**Excerpted from [Programming Guide for GemStone/S 64 Bit][3], Section 8.2**

---

*GemStone detects conflict by comparing your read and write sets with those of all other
transactions committed since your transaction began. The following conditions signal a
possible concurrency conflict:
- An object in your write set is also in the write set of another transaction—a write-write
conflict. Write-write conflicts can involve only a single object.
- An object in your write set is also in another session’s dependency list—a writedependency
conflict. An object belongs to a session’s dependency list if the session has
added, removed, or changed a dependency (index) for that object. For details about
how GemStone creates and manages indexes on collections, see Chapter 7, Indexes
and Querying.

If a write-write or write-dependency conflict is detected, then your transaction cannot
commit. This mode allows an occasional out-of-date entry to overwrite a more current
one. You can use object locks to enforce more stringent control if you can anticipate the
problem.*

---

[1]: https://gemstonesoup.wordpress.com/2007/05/10/porting-application-specific-seaside-threads-to-gemstone/
[2]: http://downloads.gemtalksystems.com/docs/GemStone64/3.2.x/GS64-Topaz-3.2.pdf
[3]: http://downloads.gemtalksystems.com/docs/GemStone64/3.2.x/GS64-ProgGuide-3.2.pdf
[4]: http://seaside.st/
[5]: https://gemstonesoup.wordpress.com/2008/03/09/glass-101-simple-persistence/
