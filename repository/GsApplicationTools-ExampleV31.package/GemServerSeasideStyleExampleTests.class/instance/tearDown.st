running
tearDown
  | gemServer |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  super tearDown.
  gemServer
    doCommitTransaction;
    stopGems.
  (Delay forSeconds: 3) wait