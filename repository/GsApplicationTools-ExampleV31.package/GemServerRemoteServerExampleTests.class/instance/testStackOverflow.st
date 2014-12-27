tests
testStackOverflow
  | gemServer client completed |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer
    enableCreateContinuations: true;
    tracing: true.
  gemServer scriptLogEvent: '---->testStackOverflow' object: gemServer.
  client := self gemClientClass new.
  completed := self
    runTest: gemServer
    client: client
    task: client scheduleStackOverflow