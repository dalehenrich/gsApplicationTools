*gsapplicationtools-serverv24
performOnServer: commandLine
  | commandResult |
  commandResult := System performOnServer: commandLine.
  ^ commandResult