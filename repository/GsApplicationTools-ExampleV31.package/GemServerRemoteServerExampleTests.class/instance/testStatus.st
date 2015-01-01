tests
testStatus
  | gemServer client |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer
    enableCreateContinuations: true;
    tracing: true.
  gemServer scriptLogEvent: '---->testStatus' object: gemServer.
  client := self gemClientClass new.
  self runTest: gemServer client: client task: client scheduleStatusTask