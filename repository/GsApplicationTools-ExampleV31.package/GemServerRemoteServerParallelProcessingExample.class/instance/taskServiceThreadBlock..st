service instance-server
taskServiceThreadBlock: task
  ^ [ 
  [ 
  self
    gemServer: [ 
      "handle exceptions (including breakpoints and Halt) that occur while processing individual task"
      self trace: [ 'start process task [3] ' , task label ] object: [ task ].
      [ task processTask: self ]
        ensure: [ 
          self doTransaction: [ self inProcess remove: task ].
          self trace: [ 'end process task [4] ' , task label ] object: [ task ] ] ]
    exceptionSet:
      GemServerRemoteInternalServerErrorTriggerExample , self gemServerExceptionSet
    beforeUnwind: [ :ex | 
      self
        doTransaction: [ 
          task exception: ex.
          (ObjectLogEntry
            error:
              'Server example task exception: ' , ex description printString
            object: task) addToLog ] ] ]
    ensure: [ 
      activeProcessesMutex
        critical: [ self activeProcesses value remove: Processor activeProcess ifAbsent: [  ] ] ] ]