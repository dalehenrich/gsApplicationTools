server specialization
executeGemCommand: command
  "override as necessary"

  | commandLine performOnServerStatusArray |
  Transcript
    cr;
    show: '---' , command , ' server gems' , ' (';
    show: TimeStamp now printString;
    show: ')'.
  commandLine := self scriptPath , ' ' , command , ' "' , self name , '" '
    , self portString.
  self performOnServer: commandLine.
  Transcript
    cr;
    show: performOnServerStatusArray withSqueakLineEndings.
  Transcript
    cr;
    show: '---Finished server gems ' , command printString , ' (';
    show: TimeStamp now printString;
    show: ')'