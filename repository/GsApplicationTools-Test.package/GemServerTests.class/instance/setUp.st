running
setUp
  super setUp.
  self stopGems: (GemServerTestServer register: self gemServerName).
  System commitTransaction