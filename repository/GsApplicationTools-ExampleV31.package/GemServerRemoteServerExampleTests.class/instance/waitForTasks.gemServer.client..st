private
waitForTasks: taskList gemServer: gemServer client: client
  | ar completed valid |
  ar := client waitForTasks: taskList gemServer: gemServer.
  completed := ar at: 3.
  Transcript
    cr;
    show: 'Checking completed tasks: ' , (ar at: 1) printString.
  1 to: completed size do: [ :index | 
    | task |
    task := completed at: index.
    Transcript
      cr;
      show:
          index printString , '. ' , task label , ' ::: ' , task isValid printString ].
  (ar at: 1)
    ifFalse: [ self assert: false description: 'all tasks not complete' ].
  valid := ar at: 4.
  self assert: valid size = completed size description: 'task validation error'.
  ^ valid