service instance-server
basicServerOn: ignored
  "forked by called"

  self
    gemServer: [ 
      | taskList |
      taskList := self tasks.
      [ taskList notEmpty ]
        whileTrue: [ 
          | task |
          task := taskList first.
          taskList remove: task.
          [ self handleRequestFrom: task ] fork ] ]
    exceptionSet: Error