running
setUp
  super setUp.
  (GemServerTestServer register: self gemServerName) stopGems.
  System commitTransaction