running
tearDown
  | gemServer |
  gemServer := GemServer gemServerNamed: self gemServerName.
  super tearDown.
  (ObjectLogEntry trace: 'tearDown: stopGems') addToLog.
  gemServer
    doCommitTransaction;
    stopGems