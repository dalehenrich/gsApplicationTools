accessing
inProcess
  InProcess == nil
    ifTrue: [ InProcess := RcIdentityBag new: 10 ].
  ^ InProcess