server specialization
executeStatusGemCommand: pidList
  | commandLine status |
  commandLine := ' ps -fp ' , pidList.
  status := self performOnServer: commandLine.
  Transcript
    cr;
    show: status.
  ^ status