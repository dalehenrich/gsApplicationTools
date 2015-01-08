server specialization
executeStartGemCommand: portOrResourceName
  self useEventLog
    ifFalse: [ ^ super executeStartGemCommand: portOrResourceName ].
  self eventLog add: 'start' -> portOrResourceName