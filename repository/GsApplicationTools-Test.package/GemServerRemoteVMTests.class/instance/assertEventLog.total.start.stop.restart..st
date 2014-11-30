private
assertEventLog: eventLog total: total start: start stop: stop restart: restart
  System abortTransaction.
  super
    assertEventLog: eventLog
    total: total
    start: start
    stop: stop
    restart: restart