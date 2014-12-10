service instance-server
startBasicServerOn: port
  "start server in current vm. expected to return."

  | server |
  server := self serverClass on: port.
  self serverInstance: server.
  server start