server specialization
executeGemCommand: command
  self ports do: [ :port | self eventLog add: command -> port ]