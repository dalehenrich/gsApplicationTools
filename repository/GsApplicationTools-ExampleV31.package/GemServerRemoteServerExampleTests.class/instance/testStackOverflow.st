tests
testStackOverflow
  | gemServer client completed |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer tracing: true.
  gemServer scriptLogEvent: '---->testStackOverflow' object: gemServer.
  client := GemServerRemoteClientExample new.
  completed := self
    runTest: gemServer
    client: client
    task: client scheduleStackOverflow