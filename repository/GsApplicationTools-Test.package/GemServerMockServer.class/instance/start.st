service start
start
  self class beginTransaction.
  self class eventLog add: 'start' -> port.
  self class commit