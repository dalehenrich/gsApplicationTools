tests
testSeasideStyleError
  | gemServer client |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer enableCreateContinuations: true.
  gemServer scriptLogEvent: '---->testSeasideStyleError' object: gemServer.
  gemServer
    requests:
      {(GemServerSeasideStyleExampleRequest new
        request: [ :request | request requestError ];
        expectedException: Error;
        expectedStatus: #'error';
        yourself)}.
  gemServer doCommitTransaction.
  self runTest: gemServer