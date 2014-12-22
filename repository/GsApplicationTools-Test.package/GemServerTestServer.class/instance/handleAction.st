actions
handleAction
  messageCount <= actionCount
    ifTrue: [ ^ self performNoop ].
  actionSymbol == #'forceBeginTransaction'
    ifTrue: [ ^ self performForceBeginTransaction ].
  actionSymbol == #'forceInternalServerError'
    ifTrue: [ ^ self performForceInternalServerError ].
  actionCount := actionCount + 1.	"acknowledge event handled"
  actionSymbol == #'add'
    ifTrue: [ ^ self performAdd ].
  actionSymbol == #'error'
    ifTrue: [ ^ self performError ].
  actionSymbol == #'halt'
    ifTrue: [ ^ self performHalt ].
  actionSymbol == #'serverStarted'
    ifTrue: [ ^ self performServerStarted ]