running
setUp
  super setUp.
  (GemServerRemoteServerExample register: self gemServerName) stopGems.
  System commitTransaction