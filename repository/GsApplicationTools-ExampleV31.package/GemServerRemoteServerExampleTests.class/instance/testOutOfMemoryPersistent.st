tests
testOutOfMemoryPersistent
  | gemServer client completed |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer
    enableCreateContinuations: false;
    tracing: true.
  gemServer scriptLogEvent: '---->testOutOfMemoryPersistent' object: gemServer.
  client := GemServerRemoteClientExample new.
  completed := self
    runTest: gemServer
    client: client
    task: client scheduleOutOfMemoryPersistent