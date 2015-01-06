requests
requestOutOfMemoryTemp
  | set aom |
  set := IdentitySet new.
  aom := false.
  [ 
  [ aom ]
    whileFalse: [ 
      "consume chunks of memory on stack until we fill up TOC"
      set add: (Array new: 10000 withAll: Object new) ] ]
    on: AlmostOutOfMemory
    do: [ :ex | 
      aom := true.	"avoid infinite loop"
      ex pass ].
  ^ true