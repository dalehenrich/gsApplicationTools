private
waitForTasks: taskList for: client
  | tasks loopCount completed target valid |
  loopCount := 0.
  completed := {}.
  tasks := taskList copy.
  [ tasks isEmpty ]
    whileFalse: [ 
      tasks copy
        do: [ :task | 
          client doAbortTransaction.
          (task hasError or: [ task hasValue ])
            ifTrue: [ 
              completed add: task.
              tasks remove: task ] ].
      (Delay forSeconds: 1) wait.
      loopCount := loopCount + 1.
      loopCount > (taskList size * 6)
        ifTrue: [ self assert: false description: 'all tasks not complete' ] ].
  valid := completed select: [ :each | each isValid ].
  self assert: valid size = completed size