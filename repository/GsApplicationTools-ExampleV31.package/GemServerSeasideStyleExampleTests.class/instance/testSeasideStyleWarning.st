tests
testSeasideStyleWarning
  | gemServer client |
  gemServer := GemServer gemServerNamed: self gemServerName.
  gemServer enableCreateContinuations: true.
  gemServer scriptLogEvent: '---->testSeasideStyleWarning' object: gemServer.
  gemServer
    requests:
      {(GemServerSeasideStyleExampleRequest new
        request: [ :request | request requestWarning ];
        expectedResponse: true;
        expectedStatus: #'success';
        yourself)}.
  gemServer doCommitTransaction.
  self runTest: gemServer