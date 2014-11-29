server specialization
executeStartGemCommand: port
  self useEventLog
    ifFalse: [ ^ super executeStartGemCommand: port ].
  self ports do: [ :port | self eventLog add: 'start' -> port ]