private
logAction
  self
    logEvent:
      'ACTION ' , actionCount printString , ' - ' , actionSymbol printString
    object:
      {messageCount.
      actionCount.
      messageObject.
      actionSymbol.
      actionResult}