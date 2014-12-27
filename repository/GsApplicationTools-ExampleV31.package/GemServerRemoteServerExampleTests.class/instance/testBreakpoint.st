tests
testBreakpoint
  | gemServer client completed |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer
    enableCreateContinuations: true;
    tracing: true.
  gemServer scriptLogEvent: '---->testBreakpoint' object: gemServer.
  client := self gemClientClass new.
  completed := self
    runTest: gemServer
    client: client
    task: client scheduleBreakpointTask