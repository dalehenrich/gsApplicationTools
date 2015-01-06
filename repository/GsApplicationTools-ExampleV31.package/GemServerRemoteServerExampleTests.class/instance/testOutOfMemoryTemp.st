tests
testOutOfMemoryTemp
  | gemServer client |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer
    enableCreateContinuations: true;
    tracing: true.
  gemServer scriptLogEvent: '---->testOutOfMemoryTemp' object: gemServer.
  client := self gemClientClass new.
  self runTest: gemServer client: client task: client scheduleOutOfMemoryTemp