accessing
forceBeginTransaction
  forceBeginTransaction ifNil: [ forceBeginTransaction := false ].
  ^ forceBeginTransaction