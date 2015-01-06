tests
testSeasideStyleSimple
  | gemServer client |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer enableCreateContinuations: true.
  gemServer scriptLogEvent: '---->testSeasideStyleSimple' object: gemServer.
  gemServer
    requests:
      {(GemServerSeasideStyleExampleRequest new
        request: [ :request | request requestAdd: 3 to: 4 ];
        expectedResponse: 7;
        expectedStatus: #'success';
        yourself)}.
  gemServer doCommitTransaction.
  self runTest: gemServer