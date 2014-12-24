private
waitForTasks: taskList for: client trace: trace
  | ar completed valid |
  ar := client waitForTasks: taskList trace: trace.
  (ar at: 1)
    ifFalse: [ self assert: false description: 'all tasks not complete' ].
  completed := ar at: 3.
  valid := ar at: 4.
  self assert: valid size = completed size description: 'task validation error'.
  ^ valid