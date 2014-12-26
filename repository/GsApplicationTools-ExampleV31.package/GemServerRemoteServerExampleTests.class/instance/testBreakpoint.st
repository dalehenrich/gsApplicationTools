tests
testBreakpoint
  | gemServer client completed |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer
    enableCreateContinuations: false;
    tracing: false.
  gemServer scriptLogEvent: '---->testBreakpoint' object: gemServer.
  client := GemServerRemoteClientExample new.
  completed := self
    runTest: gemServer
    client: client
    task: client scheduleBreakpointTask