private
assertEventLog: eventLog total: total start: start stop: stop restart: restart
  self assert: eventLog size = total.
  self assert: (eventLog select: [ :assoc | assoc key = 'start' ]) size = start.
  self assert: (eventLog select: [ :assoc | assoc key = 'stop' ]) size = stop.
  self
    assert: (eventLog select: [ :assoc | assoc key = 'restart' ]) size = restart