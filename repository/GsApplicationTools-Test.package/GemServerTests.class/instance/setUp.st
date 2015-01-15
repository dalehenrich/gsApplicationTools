running
setUp
  "(GemServer gemServerNamed: 'Test_Server') stopGems"

  super setUp.
  (GemServerTestServer register: self gemServerName) stopGems.
  System commitTransaction