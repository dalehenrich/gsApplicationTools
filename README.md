gsApplicationTools [![master branch:](https://travis-ci.org/GsDevKit/gsApplicationTools.png?branch=master)](https://travis-ci.org/GsDevKit/gsApplicationTools)
==================

This repository includes scripts and code that allow a more convenient setup of a Gemstone server application 

## GemStone Installation

```Smalltalk
Gofer new
  package: 'GsUpgrader-Core';
  url: 'http://ss3.gemtalksystems.com/ss/gsUpgrader';
  load.
(Smalltalk at: #GsUpgrader) upgradeGrease.

GsDeployer deploy: [
  "Load GsApplicationTools packages"
  Metacello new
    baseline: 'GsApplicationTools';
    repository: 'github://GsDevKit/gsApplicationTools:master/repository';
    load: #('')
].
```

## Examples

### WebSocket example

```Smalltalk
  | gemServer |
  "Register GemServer using a ZnWebSocketStatusHandler delegate"
  gemServer := (ZnGemServer register: 'ZnWebSocketTestStatusServer' on: #(1701))
    delegate:
        (ZnWebSocketDelegate map: 'ws-status' to: ZnWebSocketStatusHandler new);
    yourself.
    
  gemServer startGems. "start GemServers ... in this case a single GemServer on port 1701"
  
  webSocket := ZnWebSocket to: 'ws://localhost:1701/ws-status'.
  "do something with the WebSocket"
  webSocket close.
  
  gemServer stopGems. "stop the GemServers when you are done"
```

By default, a **ZnTranscriptLogger** is used. A continuation is snapped off and saved to ObjectLog when an error is logged. The **ZnTranscriptLogger** dumps a stack to the gem log.

### Debugging a separate GemServer
`logToObjectLog` arranges for the Zinc logging to go the object log. 
`logToTranscript` may be used to route logging to go to Transcript, which ends up being written to the gem log.
By default only error events are logged.
Also by default error continuations are dumped to the object log (whether or not you have specified object log logging). 
`enableContinuations: false` can be used to disable logging of error continuations.
`logEverything` arranges for all log events to be logged.
`logFilter:` can be used to set a custom log filter.

The following causes all log entries to be dumped to object log:

```Smalltalk
  | gemServer |
  gemServer := (ZnGemServer register: 'ZnWebSocketTestStatusServer' on: #(1701))
    logToObjectLog;
    logEverything;
    delegate:
        (ZnWebSocketDelegate map: 'ws-status' to: ZnWebSocketStatusHandler new);
    yourself.
  gemServer startGems.
  webSocket := ZnWebSocket to: 'ws://localhost:1701/ws-status'.
  "do something with the WebSocket"
  webSocket close.
  gemServer stopGems.
```

The tODE object log viewer:

```Shell
ol view --age=`1 hour`
```

can be used to view log entries and debug error continuations:

```
info        Start Gems: ZnWebSocketTestEchoServ...  29691  11/30/2014 20:05:11:692
info        performOnServer: ZnWebSocketTestEch...  29691  11/30/2014 20:05:11:702
info        -->>Start ZnWebSocketTestEchoServer...  30617  11/30/2014 20:05:11:734
info        recordGemPid: ZnWebSocketTestEchoSe...  30617  11/30/2014 20:05:11:735
info        setStatmonCacheName: ZnWebSocketTes...  30617  11/30/2014 20:05:11:740
info        enableRemoteBreakpointHandling: ZnW...  30617  11/30/2014 20:05:11:741
info        startSigAbortHandling: ZnWebSocketT...  30617  11/30/2014 20:05:11:780
info        Start: ZnManagingMultiThreadedServe...  30617  11/30/2014 20:05:11:818
info        Starting ZnManagingMultiThreadedSer...  30617  11/30/2014 20:05:11:853
debug       Initializing server socket              30617  11/30/2014 20:05:11:894
debug       Executing request/response loop         30617  11/30/2014 20:05:14:704
info        Read aZnRequest(GET /ws-echo)           30617  11/30/2014 20:05:14:755
trace       GET /ws-echo 101 4ms                    30617  11/30/2014 20:05:14:798
info        Wrote aZnWebSocketResponse(101 Swit...  30617  11/30/2014 20:05:14:837
info        Received message: 'Greetings from G...  30617  11/30/2014 20:05:14:878
error       -- continuation -- (a ArgumentError...  30617  11/30/2014 20:05:44:921
error       a ArgumentError occurred (error 201...  30617  11/30/2014 20:05:44:960
debug       Closing stream                          30617  11/30/2014 20:05:45:004
error       -- continuation -- (Could not remov...  30617  11/30/2014 20:05:45:044
error       Could not remove SocketStream[inbuf...  30617  11/30/2014 20:05:45:086
info        Stop Gems: ZnWebSocketTestEchoServe...  29691  11/30/2014 20:14:08:602
info        performOnServer: ZnWebSocketTestEch...  29691  11/30/2014 20:14:08:610
```


