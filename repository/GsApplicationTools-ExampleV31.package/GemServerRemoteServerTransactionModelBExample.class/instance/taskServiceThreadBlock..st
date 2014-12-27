service instance-server
taskServiceThreadBlock: task
  "use GemServer>>gemServerTransaction:exceptionSet:onError: to wrap a transaction around 
   the gemServerTransaction and onError blocks ... 'seaside-stye' transaction model"

  ^ [ 
  [ 
  self
    gemServerTransaction: [ 
      "handle exceptions (including breakpoints and Halt) that occur while processing individual task"
      self trace: [ 'start process task [3] ' , task label ] object: [ task ].
      [ task processTask: self ]
        ensure: [ 
          self inProcess remove: task.
          self trace: [ 'end process task [4] ' , task label ] object: [ task ] ] ]
    exceptionSet:
      GemServerRemoteInternalServerErrorTriggerExample , self gemServerExceptionSet
    onError: [ :ex | 
      task exception: ex.
      (ObjectLogEntry
        error: 'Server example task exception: ' , ex description printString
        object: task) addToLog ] ]
    ensure: [ 
      activeProcessesMutex
        critical: [ self activeProcesses value remove: Processor activeProcess ifAbsent: [  ] ] ] ]