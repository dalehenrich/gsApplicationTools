running
setUp
  super setUp.
  (GemServerSeasideStyleExample register: self gemServerName) stopGems.
  System commitTransaction