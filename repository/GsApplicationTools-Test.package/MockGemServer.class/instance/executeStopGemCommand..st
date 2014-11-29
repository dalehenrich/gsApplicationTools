server specialization
executeStopGemCommand: port
  self useEventLog
    ifFalse: [ ^ super executeStopGemCommand: port ].
  self eventLog add: 'stop' -> port