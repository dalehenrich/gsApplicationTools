task scheduling
submitAndWaitFor: taskSelectorList gemServer: gemServer
  | taskList |
  taskList := {}.
  taskSelectorList
    do: [ :selector | 
      | task |
      task := self perform: selector.
      task label: selector asString.
      taskList add: task ].
  self doCommitTransaction.
  ^ self waitForTasks: taskList gemServer: gemServer