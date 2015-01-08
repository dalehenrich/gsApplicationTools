tests
testSeasideStyleStackOverflow
  | gemServer client |
  gemServer := GemServer gemServerNamed: self gemServerName.
  gemServer enableCreateContinuations: true.
  gemServer
    scriptLogEvent: '---->testSeasideStyleStackOverflow'
    object: gemServer.
  gemServer
    requests:
      {(GemServerSeasideStyleExampleRequest new
        request: [ :request | request requestStackOverflow ];
        expectedException: AlmostOutOfStack;
        expectedStatus: #'error';
        yourself)}.
  gemServer doCommitTransaction.
  self runTest: gemServer.
  gemServer errorLog
    detect: [ :entry | entry object isKindOf: AlmostOutOfStack ]
    ifNone: [ self assert: false description: 'no errorLog entry for AlmostOutOfStack' ]