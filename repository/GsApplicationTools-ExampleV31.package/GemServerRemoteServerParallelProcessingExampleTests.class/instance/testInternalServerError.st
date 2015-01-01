tests
testInternalServerError
  | gemServer client |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer
    enableCreateContinuations: true;
    tracing: true.
  gemServer scriptLogEvent: '---->testInternalServerError' object: gemServer.
  client := self gemClientClass new.
  self
    runTest: gemServer
    client: client
    task: client scheduleInternalServerError