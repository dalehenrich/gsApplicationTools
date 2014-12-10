*gsapplicationtools-serverv24
enableRemoteBreakpointHandling
  "Enable remote Breakpoing handling"

  self enableRemoteBreakpoints
    ifFalse: [ ^ self ].
  self
    scriptLogEvent: 'enableRemoteBreakpointHandling: ' , self name
    object: self.
  GemToGemAnnouncement installStaticHandler.
  Exception
    installStaticException: [ :ex :cat :num :args | 
      BreakpointNotification signal.	"needed to avoid infinite loop when resuming from a breakpoint"
      ex _incrementBreakpointsToIgnore ]
    category: GemStoneError
    number: 6005
    subtype: nil.
  System commitTransaction
    ifFalse: [ self error: 'Could not commit for GemToGemSignaling' ]