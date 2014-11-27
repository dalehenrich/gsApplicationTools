session server start
startServerInCurrentSession: serverName onPort: aPort
  "start server directly in the current session ... will block"

  (self gemServerNamed: serverName) imageStartOn: aPort