server specialization
executeStatusGemCommand: pidList
  | commandLine status |
  commandLine := ' ps -wwfp ' , pidList.
  status := self performOnServer: commandLine.
  Transcript
    cr;
    show: status.
  ^ status