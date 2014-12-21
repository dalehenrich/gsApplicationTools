server specialization
executeStatusGemCommand: pidList
  | commandLine |
  commandLine := ' ps -wwfp ' , pidList.
  ^ self
    performOnServer: commandLine
    status: [ :performOnServerStatusArray | 
      | status |
      "for status, we don;t care if the command fails ... could happen if a gem isn't running"
      status := (performOnServerStatusArray at: 3) asString.
      Transcript
        cr;
        show: status.
      status ]