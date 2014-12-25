server compat
stop
  super stop.
  self activeProcesses copy
    do: [ :proc | 
      proc terminate.
      activeProcessesMutex
        critical: [ self activeProcesses remove: proc ifAbsent: [  ] ] ]