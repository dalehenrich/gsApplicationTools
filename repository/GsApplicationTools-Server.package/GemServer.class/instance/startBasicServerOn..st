service instance-server
startBasicServerOn: portOrNil
  "start basic server process in current vm. fork and record forked process instance. expected to return."

  self basicServerProcess: [ self basicServerOn: portOrNil ] fork.
  self serverInstance: self	"the serverProcess is session-specific"