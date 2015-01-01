operations
outOfMemoryTempMethod
  | set aom |
  Transcript
    cr;
    show: 'outOfMemoryTempMethod'.
  self assert: AlmostOutOfMemory enabled.
  set := IdentitySet new.
  aom := false.
  [ 
  [ aom ]
    whileFalse: [ 
      "consume chunks of memory on stack until we fill up TOC"
      Transcript show: '.'.
      set add: (Array new: 10000 withAll: Object new) ] ]
    on: AlmostOutOfMemory
    do: [ :ex | 
      aom := true.	"avoid infinite loop"
      Transcript show: '{'.
      ex pass.
      Transcript show: '}' ].
  Transcript show: 'done'