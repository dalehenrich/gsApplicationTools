service instance-server
processTasksOnQueue
  | tasks |
  self
    doTransaction: [ 
      tasks := self queue removeAll.
      self inProcess addAll: tasks ].
  self trace: [ 'tasks [1] ' , tasks size printString ] object: [ tasks copy ].
  tasks
    do: [ :task | 
      | proc |
      self trace: [ 'fork task [2] ' , task label ] object: [ task ].
      proc := TransientStackValue
        value: (self taskServiceThreadBlock: task) fork.
      activeProcessesMutex critical: [ self activeProcesses add: proc value ].
      self
        trace: [ 
          'task [5] inProcess: ' , self inProcess size printString , ' activeProcesses: '
            , self activeProcesses size printString ]
        object: [ self status ].
      Processor yield ]