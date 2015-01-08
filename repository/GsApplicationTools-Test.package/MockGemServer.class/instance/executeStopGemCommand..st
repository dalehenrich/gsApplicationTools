server specialization
executeStopGemCommand: portOrResourceName
  self useEventLog
    ifFalse: [ ^ super executeStopGemCommand: portOrResourceName ].
  self eventLog add: 'stop' -> portOrResourceName