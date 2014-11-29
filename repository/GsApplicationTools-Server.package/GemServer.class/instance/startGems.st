service instance-control
startGems
  System commitTransaction
    ifFalse: [ self error: 'Commit transaction failed before startGems' ].
  self ports do: [ :port | self executeStartGemCommand: port ]