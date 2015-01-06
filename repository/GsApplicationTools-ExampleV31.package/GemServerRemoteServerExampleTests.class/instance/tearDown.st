running
tearDown
  | gemServer |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  super tearDown.
  (ObjectLogEntry trace: 'tearDown: stopGems') addToLog.
  gemServer
    doCommitTransaction;
    stopGems