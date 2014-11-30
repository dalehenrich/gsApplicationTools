service instance-server
startServerOn: port
  "start server in current vm."

  (self serverClass on: port) start