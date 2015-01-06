accessing
expectedLoopCount
  expectedLoopCount ifNil: [ expectedLoopCount := self requests size * 2 ].
  ^ expectedLoopCount