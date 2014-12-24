running
setUp
  super setUp.
  (GemServerRemoteServerExample register: self gemServerName) stopGems.
  (ObjectLogEntry trace: 'setup: stopGems') addToLog.
  GemServerRemoteTaskExample reset.
  System commitTransaction