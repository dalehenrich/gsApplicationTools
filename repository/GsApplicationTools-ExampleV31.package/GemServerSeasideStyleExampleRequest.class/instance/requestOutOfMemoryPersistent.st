requests
requestOutOfMemoryPersistent
  | set aom |
  set := UserGlobals
    at: #'Seaside_GemServer_OutOfMemorySet'
    put: IdentitySet new.
  aom := 0.
  [ aom < 2 ]
    whileTrue: [ 
      [ 
      "consume chunks of memory rooted in UserGlobals until we fill up TOC"
      set add: (Array new: 100000 withAll: Object new) ]
        on: AlmostOutOfMemory
        do: [ :ex | 
          "we'll burn TOC twice to prove that we survived the fist fillup"
          aom := aom + 1.
          ex pass ] ]