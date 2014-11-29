server specialization
executeStartGemCommand: port
  self useEventLog
    ifFalse: [ ^ super executeStartGemCommand: port ].
  self eventLog add: 'start' -> port