tests
testError
  | gemServer client completed |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer
    enableCreateContinuations: true;
    tracing: true.
  gemServer scriptLogEvent: '---->testError' object: gemServer.
  client := self gemClientClass new.
  completed := self
    runTest: gemServer
    client: client
    task: client scheduleErrorTask