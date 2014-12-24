running
tearDown
  | gemServer |
  super tearDown.
  (ObjectLogEntry trace: 'tearDown: stopGems') addToLog.
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer
    doCommitTransaction;
    stopGems