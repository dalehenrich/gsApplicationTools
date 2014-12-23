running
tearDown
  super tearDown.
  (GemServerRegistry gemServerNamed: self gemServerName) stopGems