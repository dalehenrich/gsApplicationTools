*gsapplicationtools-serverv24
performOnServer: commandLine status: statusBlock
  | result performOnServerStatusArray |
  result := System performOnServer: commandLine.
  performOnServerStatusArray := {0.
  0.
  result.
  0.
  ''}.	"simulate result array in 3.x:
          Array of 5 elements: 
          raw status Integer, 
          child process status Integer (after WEXITSTATUS macro applied), 
          result String (or nil if operation failed) ,
          error string from script file write, fork, or result file read ,
          errno value, a SmallInteger from file write, fork, or file read"
  self
    scriptLogEvent: 'performOnServer: ' , self name
    object:
      {commandLine.
      performOnServerStatusArray}.
  ^ statusBlock value: performOnServerStatusArray