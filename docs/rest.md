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
  - [Continuations in Object Log](#continuations-in-object-log)
  - [Remote Breakpoints (3.2.4 and beyond)](#remote-breakpoints)
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
./rest --client=rest --uri=objects --post=`Dictionary with: #x -> 1 with: #y -> 1`; edit
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
info        Restart Gems: rest                                     31847  12/05/2014 15:14:04:463
info        Stop Gems: rest                                        31847  12/05/2014 15:14:04:463
info        performOnServer: rest                                  31847  12/05/2014 15:14:04:472
info        Start Gems: rest                                       31847  12/05/2014 15:14:04:506
info        performOnServer: rest                                  31847  12/05/2014 15:14:04:516
info        -->>Start rest on 1720                                 3398   12/05/2014 15:14:04:544
info        recordGemPid: rest on 1720                             3398   12/05/2014 15:14:04:545
info        setStatmonCacheName: rest                              3398   12/05/2014 15:14:04:547
info        enableRemoteBreakpointHandling: rest                   3398   12/05/2014 15:14:04:547
info        startSigAbortHandling: rest                            3398   12/05/2014 15:14:04:619
info        Starting ZnManagingMultiThreadedServer HTTP port 1...  3398   12/05/2014 15:14:04:658
debug       Initializing server socket                             3398   12/05/2014 15:14:04:690
debug       Executing request/response loop                        3398   12/05/2014 15:14:09:414
info        Read aZnRequest(POST /storage/objects)                 3398   12/05/2014 15:14:09:500
trace       POST /storage/objects 201 25B 51ms                     3398   12/05/2014 15:14:09:615
info        Wrote aZnResponse(201 Created application/json 25B...  3398   12/05/2014 15:14:09:649
info        startServerOn Delay expired.                           3398   12/05/2014 15:14:14:724
debug       Executing request/response loop                        3398   12/05/2014 15:14:17:323
info        Read aZnRequest(GET /storage/objects/1001)             3398   12/05/2014 15:14:17:366
trace       GET /storage/objects/1001 200 69B 1ms                  3398   12/05/2014 15:14:17:400
info        Wrote aZnResponse(200 OK application/json 69B)         3398   12/05/2014 15:14:17:432
error       -- continuation -- (ConnectionClosed: Connection c...  3398   12/05/2014 15:14:21:381
error       ConnectionClosed: Connection closed while waiting ...  3398   12/05/2014 15:14:21:408
debug       Closing stream                                         3398   12/05/2014 15:14:21:433
error       -- continuation -- (ConnectionClosed: Connection c...  3398   12/05/2014 15:14:21:467
error       ConnectionClosed: Connection closed while waiting ...  3398   12/05/2014 15:14:21:500
debug       Closing stream                                         3398   12/05/2014 15:14:21:533
info        startServerOn Delay expired.                           3398   12/05/2014 15:14:24:766
info        startServerOn Delay expired.                           3398   12/05/2014 15:14:34:799
info        startServerOn Delay expired.                           3398   12/05/2014 15:14:44:842
info        startServerOn Delay expired.                           3398   12/05/2014 15:14:54:885
```

If you click on an item, you will be presented with an inspector on the ObjectLogEntry instance:

```
.            -> 4 Read aZnRequest(POST /storage/objects)(3398)->aZnLogEvent
(class)@     -> ObjectLogEntry
(oop)@       -> 225769217
(committed)@ -> true
label@       -> 'Read aZnRequest(POST /storage/objects)'
object@      -> 2014-12-05 15:14:9.4998838901519775E00 881795 I Read aZnRequest(POST /storage/objects)
pid@         -> 3398
priority@    -> 4
stamp@       -> 2014-12-05T15:14:09.500468969345-08:00
tag@         -> nil
```

Clicking on the `object@` line will bring up an inspector on the a ZnLogEvent instance:

```
.            -> 2014-12-05 15:14:9.4998838901519775E00 881795 I Read aZnRequest(POST /storage/objects)
..           -> 4 Read aZnRequest(POST /storage/objects)(3398)->aZnLogEvent
(class)@     -> ZnLogEvent
(oop)@       -> 225770753
(committed)@ -> true
category@    -> #'info'
label@       -> nil
message@     -> 'Read aZnRequest(POST /storage/objects)'
processId@   -> 881795
timeStamp@   -> 12/05/2014 15:14:09
```

##### Continuations in Object Log
If an error occurs during processing a debuggable continuation is created like this one (in tODE errors are displayed in bold):

```
error       -- continuation -- (ConnectionClosed: Connection c...  3398   12/05/2014 15:14:21:381
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
12. [] in ZnManagingMultiThreadedServer(ZnMultiThreadedServer)>>readRequestSafely: @5 line 16
13. ConnectionClosed(AbstractException)>>_executeHandler: @3 line 8
14. ConnectionClosed(AbstractException)>>_signalWith: @1 line 1
15. ConnectionClosed(AbstractException)>>signal: @3 line 7
16. ConnectionClosed class(AbstractException class)>>signal: @3 line 4
17. SocketStreamSocket>>receiveDataSignallingTimeout:into:startingAt: @10 line 14
18. SocketStream>>receiveData @5 line 12
19. SocketStream>>next @7 line 9
20. ZnLineReader>>processNext @5 line 4
21. ZnLineReader>>nextLine @3 line 3
22. ZnRequestLine>>readFrom: @3 line 3
23. ZnRequestLine class>>readFrom: @3 line 3
24. ZnRequest>>readHeaderFrom: @2 line 2
25. ZnRequest(ZnMessage)>>readFrom: @2 line 2
26. ZnRequest class(ZnMessage class)>>readFrom: @3 line 3
27. [] in ExecBlock(ZnServer)>>reader @2 line 4
28. [] in ZnManagingMultiThreadedServer(ZnSingleThreadedServer)>>readRequest: @3 line 6
29. [] in ExecBlock(ZnSingleThreadedServer)>>withMaximumEntitySizeDo: @2 line 6
30. [] in ZnMaximumEntitySize class(DynamicVariable class)>>value:during: @3 line 9
31. ZnMaximumEntitySize class(ExecBlock)>>ensure: @2 line 12
32. ZnMaximumEntitySize class(DynamicVariable class)>>value:during: @6 line 10
33. ZnManagingMultiThreadedServer(ZnSingleThreadedServer)>>withMaximumEntitySizeDo: @5 line 5
34. ZnManagingMultiThreadedServer(ZnSingleThreadedServer)>>readRequest: @2 line 6
35. [] in ZnManagingMultiThreadedServer(ZnMultiThreadedServer)>>readRequestSafely: @2 line 5
36. ZnManagingMultiThreadedServer(ExecBlock)>>on:do: @3 line 42
37. [] in ZnManagingMultiThreadedServer(ZnMultiThreadedServer)>>readRequestSafely: @3 line 6
38. ZnManagingMultiThreadedServer(ExecBlock)>>on:do: @3 line 42
39. ZnManagingMultiThreadedServer(ZnMultiThreadedServer)>>readRequestSafely: @3 line 13
40. ZnManagingMultiThreadedServer(ZnMultiThreadedServer)>>executeOneRequestResponseOn: @2 line 7
41. [] in ZnManagingMultiThreadedServer(ZnMultiThreadedServer)>>executeRequestResponseLoopOn: @2 line 10
42. [] in ZnCurrentServer class(DynamicVariable class)>>value:during: @3 line 9
43. ZnCurrentServer class(ExecBlock)>>ensure: @2 line 12
44. ZnCurrentServer class(DynamicVariable class)>>value:during: @6 line 10
45. [] in ZnManagingMultiThreadedServer(ZnMultiThreadedServer)>>executeRequestResponseLoopOn: @4 line 9
46. ZnManagingMultiThreadedServer(ExecBlock)>>on:do: @3 line 42
47. ZnManagingMultiThreadedServer(ZnMultiThreadedServer)>>executeRequestResponseLoopOn: @4 line 11
48. [] in ZnManagingMultiThreadedServer(ZnMultiThreadedServer)>>serveConnectionsOn: @2 line 12
49. ZnManagingMultiThreadedServer(ExecBlock)>>on:do: @3 line 42
50. [] in ZnManagingMultiThreadedServer(ZnMultiThreadedServer)>>serveConnectionsOn: @2 line 13
51. ZnManagingMultiThreadedServer(ExecBlock)>>ensure: @2 line 12
52. [] in ZnManagingMultiThreadedServer(ZnMultiThreadedServer)>>serveConnectionsOn: @2 line 15
53. [] in ExecBlock>>ifCurtailed: @2 line 6
54. ExecBlock>>ensure: @2 line 12
55. ZnManagingMultiThreadedServer(ExecBlock)>>ifCurtailed: @3 line 8
56. [] in ZnManagingMultiThreadedServer(ZnMultiThreadedServer)>>serveConnectionsOn: @2 line 18
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
The following sets a breakpoint at the first step point in ZnRestServerDelegate>>handleRequest::

```Shell
break set ZnRestServerDelegate>>handleRequest:
```

If you want to set a breakpoint somewhere else in the method, you can do so interactively by using the `Method>>set breakpoint (k)` menu item in a method editor or you may use the `break step` command to list the breakpoints in a method:

```Shell
break steps ZnRestServerDelegate>>handleRequest:
```

produces the following output:

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

and step point 14 looks like a good place to put a break (at the beginning of the **execute:** call).
So let's set a breakpoint there:

```Shell
break set ZnRestServerDelegate>>handleRequest: 14
```

Run a `post` command to trigger the breakpoint:

```Shell
./rest --client=rest --uri=objects --post=`Dictionary with: #x -> 1 with: #y -> 1`
```



```Shell
./rest
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
./rest --client=rest --uri=objects --post=`Dictionary with: #x -> 1 with: #y -> 1`
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
    contents: (Dictionary with: #'x' -> 1 with: #'y' -> 1);
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

