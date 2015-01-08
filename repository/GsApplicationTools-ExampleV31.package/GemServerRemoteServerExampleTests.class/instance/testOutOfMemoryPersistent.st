tests
testOutOfMemoryPersistent
  | gemServer client |
  gemServer := GemServer gemServerNamed: self gemServerName.
  gemServer
    enableCreateContinuations: true;
    tracing: true.
  gemServer scriptLogEvent: '---->testOutOfMemoryPersistent' object: gemServer.
  client := self gemClientClass new.
  self
    runTest: gemServer
    client: client
    task: client scheduleOutOfMemoryPersistent