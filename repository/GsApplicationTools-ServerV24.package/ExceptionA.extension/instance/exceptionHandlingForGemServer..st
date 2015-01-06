*gsapplicationtools-serverv24
exceptionHandlingForGemServer: aGemServer
  self isResumable
    ifTrue: [ aGemServer gemServerHandleResumableException: self ]
    ifFalse: [ aGemServer gemServerHandleNonResumableException: self ]