operations
outOfMemoryTempMethod
  | set |
  set := IdentitySet new.
  [ true ]
    whileTrue: [ 
      "consume chunks of memory on stack until we fill up TOC"
      set add: (Array new: 100000 withAll: Object new) ].
  ^ set