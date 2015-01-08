tests
testSeasideStyleOutOfMemoryPersistent
  | gemServer client |
  gemServer := GemServer gemServerNamed: self gemServerName.
  gemServer enableCreateContinuations: true.
  gemServer
    scriptLogEvent: '---->testSeasideStyleOutOfMemoryPersistent'
    object: gemServer.
  gemServer
    requests:
      {(GemServerSeasideStyleExampleRequest new
        request: [ :request | request requestOutOfMemoryPersistent ];
        expectedException: AlmostOutOfMemory;
        expectedStatus: #'error';
        yourself)}.
  gemServer doCommitTransaction.
  self runTest: gemServer.
  gemServer errorLog
    detect: [ :entry | entry object isKindOf: AlmostOutOfMemory ]
    ifNone: [ self assert: false description: 'no errorLog entry for AlmostOutOfMemory' ]