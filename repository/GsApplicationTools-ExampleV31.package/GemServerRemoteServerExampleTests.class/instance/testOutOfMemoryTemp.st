tests
testOutOfMemoryTemp
  | gemServer client completed |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer
    enableCreateContinuations: false;
    tracing: true.
  gemServer scriptLogEvent: '---->testOutOfMemoryTemp' object: gemServer.
  client := GemServerRemoteClientExample new.
  completed := self
    runTest: gemServer
    client: client
    task: client scheduleOutOfMemoryTemp