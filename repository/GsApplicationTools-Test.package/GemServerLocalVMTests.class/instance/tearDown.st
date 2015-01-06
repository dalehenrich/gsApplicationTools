running
tearDown
  super tearDown.
  process
    ifNotNil: [ :proc | 
      process := nil.
      proc terminate ]