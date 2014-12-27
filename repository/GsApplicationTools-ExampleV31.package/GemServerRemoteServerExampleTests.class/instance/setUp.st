running
setUp
  super setUp.
  (self gemServerClass register: self gemServerName) stopGems.
  (ObjectLogEntry trace: 'setup: stopGems') addToLog.
  GemServerRemoteTaskExample reset.
  System commitTransaction