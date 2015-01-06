accessing
queue
  Queue ifNil: [ Queue := RcQueue new: 10 ].
  ^ Queue