server specialization
executeGemCommand: command
  self useEventLog
    ifFalse: [ ^ super executeGemCommand: command ].
  self ports do: [ :port | self eventLog add: command -> port ]