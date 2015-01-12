accessing
persistentRoot
  PersistentRoot ifNil: [ PersistentRoot := Dictionary new ].
  ^ PersistentRoot