running
tearDown
  | gemServer |
  gemServer := GemServer gemServerNamed: self gemServerName.
  super tearDown.
  gemServer
    doCommitTransaction;
    stopGems.
  (Delay forSeconds: 3) wait