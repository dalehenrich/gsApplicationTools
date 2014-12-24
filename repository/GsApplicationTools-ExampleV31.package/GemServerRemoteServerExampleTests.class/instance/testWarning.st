tests
testWarning
  | gemServer client completed |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer tracing: true.
  gemServer scriptLogEvent: '---->testWarning' object: gemServer.
  client := GemServerRemoteClientExample new.
  completed := self
    runTest: gemServer
    client: client
    task: client scheduleWarning