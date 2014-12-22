actions
handleAction
  messageCount <= actionCount
    ifTrue: [ ^ self performNoop ].
  actionCount := actionCount + 1.
  actionSymbol == #'add'
    ifTrue: [ ^ self performAdd ].
  actionSymbol == #'error'
    ifTrue: [ ^ self performError ].
  actionSymbol == #'halt'
    ifTrue: [ ^ self performHalt ].
  actionSymbol == #'serverStarted'
    ifTrue: [ ^ self performServerStarted ]