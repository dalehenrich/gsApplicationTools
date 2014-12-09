GemServer support of Zinc REST
-----------------

The REST examples in this document are base on using the **ZnExampleStorageRestServerDelegate**.
From the class comment:

> I offer a REST interface on /storage with CRUD operations on JSON maps. 
> I automatically use the call hierarchy below ZnExampleStorageRestCall.

- [Installation](#installation)
- [tODE `rest` script](#tode-rest-script)
  - [`rest` Server commands](#rest-gemserver-commands)
  - [`rest` Client commands ](#rest-client-commands)
    - [Post](#post)
    - [Get](#get)
- [Debugging Server](#debugging-server)
  - [Object Log](#object-log)
  - [Debugging continuations in theObject Log](#debugging-continuations-in-the-object-log)
  - [Remote Breakpoints (3.2.4 and beyond)](#remote-breakpoints)
- [tODE Script Appendix](#tode-script-appendix)
- [Smalltalk Expression Appendix](#smalltalk-expression-appendix)
  - [Zinc REST Installation](#zinc-rest-installation)
  - [Register REST GemServer](#register-rest-gemserver)
  - [Start/Stop/Restart GemServer](#startstoprestart-gemserver)
  - [Unregister GemServer](#unregister-gemserver)
  - [Client `post` command](#client-post-command)
  - [Client `get` command](#client-get-command)
  - []()

**Note: All of the code snippets in this document (with the exception of the code in the [Smalltalk Expression Appendix](#smalltalk-expression-appendix)) should be evaluated in a tODE shell window.**

#### Installation
Install Zinc REST support ([**smalltalk code**](#zinc-rest-installation)):

```Shell
project load --loads=REST --baseline \
        --repository=github://GsDevKit/zinc:issue_58/repository ZincHTTPComponents  
```

Browse the classes used in this example:

```Shell
browse class --exact --hier ZnExampleStorageRestCall ZnExampleStorageRestServerDelegate \
       ZnAbstractExampleStorageRestServerDelegateTest ZnGemServer
```

#### tODE `rest` script
Mount the example script directory in your `/home` directory:  

```Shell
mount /sys/stone/repos/gsApplicationTools/tode/ /home gemServerExample
cd /home/gemServerExample
```

Script man page:

```Shell
./rest --help
```

##### `rest` Server commands

Register the GemServer ([**smalltalk code**](#register-rest-gemserver)):

```Shell
./rest --register=rest --port=1720 --log=all --logTo=objectLog
```

Start/stop/restart GemServer ([**smalltalk code**](#startstoprestart-gemserver)):

```Shell
./rest --start=rest
./rest --stop=rest
./rest --restart=rest
```

Unregister the GemServer ([**smalltalk code**](#unregister-gemserver]): 

```Shell
./rest --unregister=rest
```

##### `rest` Client commands

###### Post
Register a dictionary with the REST server using the `post` command ([**smalltalk code**](#client-post-command)):

```Shell
./rest --client=rest --uri=objects --post=`Dictionary with: 'x' -> 1 with: 'y' -> 1`; edit
```

The command returns the URI of the object for example: `/storage/objects/1001`.

###### Get
The `get` command returns an object ([**smalltalk code**](#client-get-command)): 

```Shell
./rest --client=rest --uri=/objects/1001 --get; edit
```

Here's the contents of tODE inspector:

```
.        -> aDictionary( 'x'->1, 'y'->1, 'object-uri'->'/storage/objects/1001')
(class)@ -> Dictionary
(oop)@   -> 217431809
1@       -> 'object-uri'->'/storage/objects/1001'
2@       -> 'x'->1
3@       -> 'y'->1
```

##### Debugging Server

The command used to register the gemServer is all set up to do remote debugging:

```Shell
./rest --register=rest --port=1720 --log=all --logTo=objectLog
```

All of the Zinc server log events are written to the object log.

##### Object Log
View the object log entries for the last hour:

```Shell
ol view --age=`1 hour`
```

and you will see a window with the following lines:

```
info   Restart Gems: rest                                     947  12/09/2014 11:48:41:082
info   Stop Gems: rest                                        947  12/09/2014 11:48:41:083
info   performOnServer: rest                                  947  12/09/2014 11:48:41:094
info   Start Gems: rest                                       947  12/09/2014 11:48:44:124
info   performOnServer: rest                                  947  12/09/2014 11:48:44:132
info   -->>Start rest on 1720                                 355  12/09/2014 11:48:44:507
info   recordGemPid: rest on 1720                             355  12/09/2014 11:48:44:508
info   setStatmonCacheName: rest                              355  12/09/2014 11:48:44:510
info   enableRemoteBreakpointHandling: rest                   355  12/09/2014 11:48:44:510
info   startSigAbortHandling: rest                            355  12/09/2014 11:48:44:553
info   Starting ZnTransactionSafeManagingMultiThreadedSer...  355  12/09/2014 11:48:44:593
debug  Initializing server socket                             355  12/09/2014 11:48:44:633
debug  Initialized server socket                              355  12/09/2014 11:48:44:675
debug  started: aZnTransactionSafeManagingMultiThreadedSe...  355  12/09/2014 11:48:44:717
debug  Executing request/response loop                        355  12/09/2014 11:49:39:148
info   Read aZnRequest(POST /storage/objects)                 355  12/09/2014 11:49:39:241
trace  POST /storage/objects 201 25B 42ms                     355  12/09/2014 11:49:39:323
info   Wrote aZnResponse(201 Created application/json 25B...  355  12/09/2014 11:49:39:365
error  -- continuation -- (ConnectionClosed: Connection c...  355  12/09/2014 11:49:39:477
error  ConnectionClosed: Connection closed while waiting ...  355  12/09/2014 11:49:39:508
debug  Closing stream                                         355  12/09/2014 11:49:39:583
debug  Executing request/response loop                        355  12/09/2014 11:50:08:372
info   Read aZnRequest(GET /storage/objects/1001)             355  12/09/2014 11:50:08:407
trace  GET /storage/objects/1001 200 69B 0ms                  355  12/09/2014 11:50:08:441
info   Wrote aZnResponse(200 OK application/json 69B)         355  12/09/2014 11:50:08:474
error  -- continuation -- (ConnectionTimedOut: Data recei...  355  12/09/2014 11:50:38:508
error  ConnectionTimedOut: Data receive timed out.            355  12/09/2014 11:50:38:548
debug  Closing stream                                         355  12/09/2014 11:50:38:581
```

If you click on an item, you will be presented with an inspector on the ObjectLogEntry instance:

```
.            -> 4 Read aZnRequest(POST /storage/objects)(355)->aZnLogEvent
(class)@     -> ObjectLogEntry
(oop)@       -> 285792769
(committed)@ -> true
label@       -> 'Read aZnRequest(POST /storage/objects)'
object@      -> 2014-12-09 11:49:3.9240653991699219E01 116272 I Read aZnRequest(POST /storage/objects)
pid@         -> 355
priority@    -> 4
stamp@       -> 2014-12-09T11:49:39.2412109375-08:00
tag@         -> nil
```

Clicking on the `object@` line will bring up an inspector on the a ZnLogEvent instance:

```
.            -> 2014-12-09 11:49:3.9240653991699219E01 116272 I Read aZnRequest(POST /storage/objects)
..           -> 4 Read aZnRequest(POST /storage/objects)(355)->aZnLogEvent
(class)@     -> ZnLogEvent
(oop)@       -> 285794305
(committed)@ -> true
category@    -> #'info'
label@       -> nil
message@     -> 'Read aZnRequest(POST /storage/objects)'
processId@   -> 116272
timeStamp@   -> 12/09/2014 11:49:39
```

##### Debugging continuations in the Object Log
If an error occurs during processing a debuggable continuation is created like this one (in tODE errors are displayed in bold):

```
error  -- continuation -- (ConnectionClosed: Connection c...  355  12/09/2014 11:49:39:477
```

If you select the `-- continuation --` and select the *debug continuation* menu item, a debugger is brought up:

```
1. DebuggerLogEntry class>>createContinuationFor: @2 line 5
2. DebuggerLogEntry class>>createContinuationLabeled: @3 line 4
3. [] in ExecBlock(ZnGemServerLogSupport)>>createContinuation: @2 line 5
4. [] in GRGemStonePlatform>>doTransaction: @3 line 17
5. GRGemStonePlatform(ExecBlock)>>ensure: @2 line 12
6. [] in GRGemStonePlatform>>doTransaction: @6 line 18
7. GRGemStonePlatform(ExecBlock)>>ensure: @2 line 12
8. TransientRecursionLock>>critical: @11 line 12
9. GRGemStonePlatform>>doTransaction: @3 line 8
10. ZnGemServerLogSupport>>createContinuation: @7 line 5
11. ZnGemServerLogSupport>>error:message: @3 line 2
12. [] in ZnTransactionSafeManagingMultiThreadedServer>>readRequestSafely: @5 line 16
13. ConnectionClosed(AbstractException)>>_executeHandler: @3 line 8
14. ConnectionClosed(AbstractException)>>_signalWith: @1 line 1
15. ConnectionClosed(AbstractException)>>signal: @3 line 7
16. ConnectionClosed class(AbstractException class)>>signal: @3 line 4
17. SocketStreamSocket>>receiveDataSignallingTimeout:into:startingAt: @10 line 14
18. SocketStream>>receiveData @6 line 15
19. SocketStream>>next @7 line 9
20. ZnLineReader>>processNext @5 line 4
21. ZnLineReader>>nextLine @3 line 3
22. ZnRequestLine>>readFrom: @3 line 3
23. ZnRequestLine class>>readFrom: @3 line 3
24. ZnRequest>>readHeaderFrom: @2 line 2
25. ZnRequest(ZnMessage)>>readFrom: @2 line 2
26. ZnRequest class(ZnMessage class)>>readFrom: @3 line 3
27. [] in ExecBlock(ZnServer)>>reader @2 line 4
28. [] in ZnTransactionSafeManagingMultiThreadedServer>>readRequest: @4 line 7
29. [] in ExecBlock(ZnSingleThreadedServer)>>withMaximumEntitySizeDo: @2 line 6
30. [] in ZnMaximumEntitySize class(DynamicVariable class)>>value:during: @3 line 9
31. ZnMaximumEntitySize class(ExecBlock)>>ensure: @2 line 12
32. ZnMaximumEntitySize class(DynamicVariable class)>>value:during: @6 line 10
33. ZnTransactionSafeManagingMultiThreadedServer(ZnSingleThreadedServer)>>withMaximumEntitySizeDo: @5 line 5
34. ZnTransactionSafeManagingMultiThreadedServer>>readRequest: @2 line 7
35. [] in ZnTransactionSafeManagingMultiThreadedServer>>readRequestSafely: @2 line 5
36. ZnTransactionSafeManagingMultiThreadedServer(ExecBlock)>>on:do: @3 line 42
37. [] in ZnTransactionSafeManagingMultiThreadedServer>>readRequestSafely: @3 line 6
38. ZnTransactionSafeManagingMultiThreadedServer(ExecBlock)>>on:do: @3 line 42
39. ZnTransactionSafeManagingMultiThreadedServer>>readRequestSafely: @3 line 13
40. ZnTransactionSafeManagingMultiThreadedServer>>executeOneRequestResponseOn: @2 line 7
41. [] in ZnTransactionSafeManagingMultiThreadedServer>>executeRequestResponseLoopOn: @2 line 9
42. [] in ZnCurrentServer class(DynamicVariable class)>>value:during: @3 line 9
43. ZnCurrentServer class(ExecBlock)>>ensure: @2 line 12
44. ZnCurrentServer class(DynamicVariable class)>>value:during: @6 line 10
45. [] in ZnTransactionSafeManagingMultiThreadedServer>>executeRequestResponseLoopOn: @4 line 8
46. ZnTransactionSafeManagingMultiThreadedServer(ExecBlock)>>on:do: @3 line 42
47. ZnTransactionSafeManagingMultiThreadedServer>>executeRequestResponseLoopOn: @4 line 10
48. [] in ZnTransactionSafeManagingMultiThreadedServer>>serveConnectionsOn: @2 line 20
49. ZnTransactionSafeManagingMultiThreadedServer(ExecBlock)>>on:do: @3 line 42
50. [] in ZnTransactionSafeManagingMultiThreadedServer>>serveConnectionsOn: @2 line 21
51. ZnTransactionSafeManagingMultiThreadedServer(ExecBlock)>>ensure: @2 line 12
52. [] in ZnTransactionSafeManagingMultiThreadedServer>>serveConnectionsOn: @2 line 23
53. [] in ExecBlock>>ifCurtailed: @2 line 6
54. ExecBlock>>ensure: @2 line 12
55. ZnTransactionSafeManagingMultiThreadedServer(ExecBlock)>>ifCurtailed: @3 line 8
56. [] in ZnTransactionSafeManagingMultiThreadedServer>>serveConnectionsOn: @2 line 26
57. GsProcess>>_start @7 line 16
58. UndefinedObject(GsNMethod class)>>_gsReturnToC @1 line 1
```

and clicking on one of the stack frames will show you the method source and bring up an inspector on the method frame.

##### Remote Breakpoints

**Note: to use remote breakpoings you must be using GemStone 3.2.4 or greater**

To use remote breakpoints, you first need to start your remote gemServer:

```Shell
./rest --restart=rest
```

Then you need to enable remote breakpoints in tODE:

```Shell
break remote --enable
```

The you need to set a breakpoint in a method of interest. 

If you want to set a breakpoint somewhere else in the method, you can do so interactively by using the `Method>>set breakpoint (k)` menu item in a method editor.

You can also use the `break set` command set a breakpoint. 
The following sets a breakpoint at the first step point in the method *ZnRestServerDelegate>>handleRequest:*:

```Shell
break set ZnRestServerDelegate>>handleRequest: 1
```

If you want to set the breakpoin somewhere else in the method, you can use the `break step` command to list the breakpoints in the method:

```Shell
break steps ZnRestServerDelegate>>handleRequest:
```

and determine the step number by looking at the output:

```
   handleRequest: request
 * ^1                                                                 *******
     | call |
     (call := self match: request) ifNil: [ ^ self noHandlerFound: request ].
 *         ^3      ^2              ^4       ^6     ^5                         
     (self authenticate: call)
 *         ^7                                                         *******
       ifFalse: [ ^ self callUnauthorized: request ].
 *     ^8         ^10    ^9                                           *******
     ^ [ self execute: call ]
 *   ^ ^      ^            ^  12,13,14,15                             *******
       on: Error
 *     ^11                                                            *******
       do: [ :exception | 
 *         ^16                                                        *******
         request server debugMode
 *               ^17    ^18                                           *******
           ifTrue: [ exception pass ]
 *         ^19                 ^20                                    *******
           ifFalse: [ 
             request server logServerError: exception.
 *                   ^22    ^23                                       *******
             self serverError: request exception: exception ] ]
 *                ^24                                        ^21      *******
```

The following sets the breakpoint at step point 14:

```Shell
break set ZnRestServerDelegate>>handleRequest: 14
```

To trigger the breakpoint, run a `post` command:

```Shell
./rest --client=rest --uri=objects --post=`Dictionary with: 'x' -> 1 with: 'y' -> 1`
```

When a Breakpoint (or Halt) is encountered, a continuation is saved to the object log and the exception is resumed, so that from the external observer, execution is not interrupted.

Here is the part of the Object Log where the Breakpoint was hit. Not that normal execution continued after hitting the breakpoint as a 201 response was returned:

```
info   Read aZnRequest(POST /storage/objects)                 355  12/09/2014 11:55:00:564
error  -- continuation -- (a Breakpoint occurred (error 6...  355  12/09/2014 11:55:00:605
trace  POST /storage/objects 201 25B 42ms                     355  12/09/2014 11:55:00:647
info   Wrote aZnResponse(201 Created application/json 25B...  355  12/09/2014 11:55:00:689
```

Here is the debugger stack for the breakpoint. Frame 12 is the spot of the Breakpoint:

```
1. DebuggerLogEntry class>>createContinuationFor: @3 line 5
2. DebuggerLogEntry class>>createContinuationLabeled: @3 line 4
3. [] in ExecBlock(ZnGemServerLogSupport)>>createContinuation: @2 line 5
4. [] in GRGemStonePlatform>>doTransaction: @4 line 12
5. TransientRecursionLock>>critical: @6 line 9
6. GRGemStonePlatform>>doTransaction: @3 line 8
7. ZnGemServerLogSupport>>createContinuation: @7 line 5
8. ZnGemServerLogSupport>>handleBreakpointException: @3 line 4
9. [] in ZnTransactionSafeManagingMultiThreadedServer>>executeRequestResponseLoopOn: @3 line 11
10. Breakpoint(AbstractException)>>_executeHandler: @3 line 8
11. Breakpoint(AbstractException)>>_signalFromPrimitive: @1 line 1
12. [] in ZnExampleStorageRestServerDelegate(ZnRestServerDelegate)>>handleRequest: @1 line 6
13. ZnExampleStorageRestServerDelegate(ExecBlock)>>on:do: @3 line 42
14. ZnExampleStorageRestServerDelegate(ZnRestServerDelegate)>>handleRequest: @11 line 7
15. [] in ZnExampleStorageRestServerDelegate>>handleRequest: @2 line 3
16. [] in GRGemStonePlatform>>doTransaction: @3 line 17
17. GRGemStonePlatform(ExecBlock)>>ensure: @2 line 12
18. [] in GRGemStonePlatform>>doTransaction: @6 line 18
19. GRGemStonePlatform(ExecBlock)>>ensure: @2 line 12
20. TransientRecursionLock>>critical: @11 line 12
21. GRGemStonePlatform>>doTransaction: @3 line 8
22. ZnExampleStorageRestServerDelegate>>handleRequest: @3 line 3
23. [] in ZnTransactionSafeManagingMultiThreadedServer(ZnSingleThreadedServer)>>authenticateAndDelegateRequest: @7 line 12
24. ZnTransactionSafeManagingMultiThreadedServer(ZnSingleThreadedServer)>>authenticateRequest:do: @4 line 6
25. ZnTransactionSafeManagingMultiThreadedServer(ZnSingleThreadedServer)>>authenticateAndDelegateRequest: @2 line 8
26. [] in ZnTransactionSafeManagingMultiThreadedServer(ZnSingleThreadedServer)>>handleRequestProtected: @2 line 5
27. ZnTransactionSafeManagingMultiThreadedServer(ExecBlock)>>on:do: @3 line 42
28. ZnTransactionSafeManagingMultiThreadedServer(ZnSingleThreadedServer)>>handleRequestProtected: @2 line 6
29. ZnTransactionSafeManagingMultiThreadedServer(ZnSingleThreadedServer)>>handleRequest: @5 line 9
30. [] in ZnTransactionSafeManagingMultiThreadedServer>>executeOneRequestResponseOn: @2 line 11
31. ZnTransactionSafeManagingMultiThreadedServer(ExecBlock)>>on:do: @3 line 42
32. ZnTransactionSafeManagingMultiThreadedServer>>executeOneRequestResponseOn: @6 line 15
33. [] in ZnTransactionSafeManagingMultiThreadedServer>>executeRequestResponseLoopOn: @2 line 9
34. [] in ZnCurrentServer class(DynamicVariable class)>>value:during: @3 line 9
35. ZnCurrentServer class(ExecBlock)>>ensure: @2 line 12
36. ZnCurrentServer class(DynamicVariable class)>>value:during: @6 line 10
37. [] in ZnTransactionSafeManagingMultiThreadedServer>>executeRequestResponseLoopOn: @4 line 8
38. ZnTransactionSafeManagingMultiThreadedServer(ExecBlock)>>on:do: @3 line 42
39. ZnTransactionSafeManagingMultiThreadedServer>>executeRequestResponseLoopOn: @4 line 10
40. [] in ZnTransactionSafeManagingMultiThreadedServer>>serveConnectionsOn: @2 line 20
41. ZnTransactionSafeManagingMultiThreadedServer(ExecBlock)>>on:do: @3 line 42
42. [] in ZnTransactionSafeManagingMultiThreadedServer>>serveConnectionsOn: @2 line 21
43. ZnTransactionSafeManagingMultiThreadedServer(ExecBlock)>>ensure: @2 line 12
44. [] in ZnTransactionSafeManagingMultiThreadedServer>>serveConnectionsOn: @2 line 23
45. [] in ExecBlock>>ifCurtailed: @2 line 6
46. ExecBlock>>ensure: @2 line 12
47. ZnTransactionSafeManagingMultiThreadedServer(ExecBlock)>>ifCurtailed: @3 line 8
48. [] in ZnTransactionSafeManagingMultiThreadedServer>>serveConnectionsOn: @2 line 26
49. GsProcess>>_start @7 line 16
50. UndefinedObject(GsNMethod class)>>_gsReturnToC @1 line 1

```

---

##tODE Script Appendix

```Shell
# installation
project load --loads=REST --baseline \
        --repository=github://GsDevKit/zinc:issue_58/repository ZincHTTPComponents
browse class --exact --hier ZnExampleStorageRestCall ZnExampleStorageRestServerDelegate \
       ZnAbstractExampleStorageRestServerDelegateTest ZnGemServer
mount /sys/stone/repos/gsApplicationTools/tode/ /home gemServerExample
cd /home/gemServerExample

# rest script
./rest --help

./rest --register=rest --port=1720 --log=all --logTo=objectLog

./rest --start=rest
./rest --stop=rest
./rest --restart=rest

./rest --client=rest --uri=objects --post=`Dictionary with: 'x' -> 1 with: 'y' -> 1`; edit
./rest --client=rest --uri=/objects/1001 --get; edit

./rest --unregister=rest

# object log viewer
ol view --age=`1 hour`

# breakpoints
break remote --enable
break steps ZnRestServerDelegate>>handleRequest:
break set ZnRestServerDelegate>>handleRequest: 14
break clear
```

---


##Smalltalk Expression Appendix

The following Smalltalk snippets are representative of the code that is executed by the tODE commands.

####Zinc REST Installation

The **tODE** command:

```Shell
project load --loads=REST --baseline \
        --repository=github://GsDevKit/zinc:issue_58/repository ZincHTTPComponents  
```

executes the following **Smalltalk**:

```Smalltalk
GsDeployer bulkMigrate: [
  Metacello new
    baseline: 'ZincHTTPComponents';
    repository: 'github://GsDevKit/zinc:issue_58/repository';
    load: 'REST' ].
```

####Register REST GemServer

The **tODE** command:

```Shell
./rest --register=rest --port=1720 --log=all --logTo=objectLog
```

executes the following **Smalltalk**:

 
```Smalltalk
(ZnGemServer register: 'rest')
    ports: #(1720);
    logFilter: nil;
    logToObjectLog;
    delegate: ZnExampleStorageRestServerDelegate new;
    register.
```

####Start/Stop/Restart GemServer

The **tODE** commands:

```Shell
./rest --start=rest
./rest --stop=rest
./rest --restart=rest
```

executes the following **Smalltalk**:

```Smalltalk
(GemServerRegistry gemServerNamed: 'rest') startGems.
(GemServerRegistry gemServerNamed: 'rest') stopGems.
(GemServerRegistry gemServerNamed: 'rest') restartGems.
```

####Unregister GemServer

The **tODE** command:

```Shell
./rest --unregister=rest
```

executes the following **Smalltalk**:

```Smalltalk
(GemServerRegistry gemServerNamed: 'rest') unregister.
```

####Client `post` command

The **tODE** command:

```Shell
./rest --client=rest --uri=objects --post=`Dictionary with: 'x' -> 1 with: 'y' -> 1`
```

executes the following **Smalltalk**:

```Smalltalk
  ZnClient new
    url: 'http://localHost:1720';
    addPathSegment: #'storage';
    accept: ZnMimeType applicationJson;
    contentReader: [ :entity | 
        entity ifNotNil: [ NeoJSONReader fromString: entity contents ] ];
    contentWriter: [ :object | 
        ZnEntity 
            with: (NeoJSONWriter toString: object) 
            type: ZnMimeType applicationJson ];
    addPathSegment: 'objects';
    contents: (Dictionary with: 'x' -> 1 with: 'y' -> 1);
    post
```

####Client `get` command

The **tODE** command:

```Shell
./rest --client=rest --uri=/objects/1001 --get
```

executes the following **Smalltalk**:

```Smalltalk
  ZnClient new
    url: 'http://localHost:1720';
    addPathSegment: #'storage';
    accept: ZnMimeType applicationJson;
    contentReader: [ :entity | 
        entity ifNotNil: [ NeoJSONReader fromString: entity contents ] ];
    contentWriter: [ :object | 
        ZnEntity 
            with: (NeoJSONWriter toString: object) 
            type: ZnMimeType applicationJson ];
    addPath: 'objects/1001';
    get;
    contents
```

