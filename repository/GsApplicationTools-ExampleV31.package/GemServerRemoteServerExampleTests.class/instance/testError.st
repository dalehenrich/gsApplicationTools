tests
testError
  | gemServer client completed |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer tracing: false.
  gemServer scriptLogEvent: '---->testError' object: gemServer.
  client := GemServerRemoteClientExample new.
  completed := self
    runTest: gemServer
    client: client
    task: client scheduleErrorTask