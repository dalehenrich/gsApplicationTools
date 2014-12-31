service instance-server
startBasicServerOn: port
  "start basic server process in current vm. fork and record forked process instance. expected to return."

  self basicServerProcess: [ self basicServerOn: port ] fork