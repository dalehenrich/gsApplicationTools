private
assertEventLog: eventLog total: total start: start stop: stop restart: restart
  self abortTransaction.
  super
    assertEventLog: eventLog
    total: total
    start: start
    stop: stop
    restart: restart