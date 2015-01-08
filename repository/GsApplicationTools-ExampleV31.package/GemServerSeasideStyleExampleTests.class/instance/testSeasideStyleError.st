tests
testSeasideStyleError
  | gemServer client |
  gemServer := GemServer gemServerNamed: self gemServerName.
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
  self runTest: gemServer.
  gemServer errorLog
    detect: [ :entry | entry object isKindOf: Error ]
    ifNone: [ self assert: false description: 'no errorLog entry for Error' ]