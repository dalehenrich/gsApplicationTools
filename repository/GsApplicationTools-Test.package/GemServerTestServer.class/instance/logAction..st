private
logAction: caller
  self
    logEvent: 'ACTION ' , actionCount printString , ' - ' , caller printString
    object: self copy