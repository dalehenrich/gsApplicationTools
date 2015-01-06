tests
testError
  | gemServer client |
  gemServer := GemServer gemServerNamed: self gemServerName.
  gemServer
    enableCreateContinuations: true;
    tracing: true.
  gemServer scriptLogEvent: '---->testError' object: gemServer.
  client := self gemClientClass new.
  self runTest: gemServer client: client task: client scheduleErrorTask