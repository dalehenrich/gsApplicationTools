tests
testSeasideStyleHalt
  | gemServer client |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer enableCreateContinuations: true.
  gemServer scriptLogEvent: '---->testSeasideStyleHalt' object: gemServer.
  gemServer
    requests:
      {(GemServerSeasideStyleExampleRequest new
        request: [ :request | request requestHalt ];
        expectedResponse: true;
        expectedStatus: #'success';
        yourself)}.
  gemServer doCommitTransaction.
  self runTest: gemServer.
  gemServer errorLog
    detect: [ :entry | entry object isKindOf: Halt ]
    ifNone: [ self assert: false description: 'no errorLog entry for Halt' ]