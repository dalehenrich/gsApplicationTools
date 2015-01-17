private
validatePidFile: gemServer shouldExist: shouldExist
  | portCount |
  portCount := 0.
  gemServer defaultPortOrResourceNameList
    do: [ :defaultPortOrResourceName | 
      | fileName |
      portCount := portCount + 1.
      fileName := gemServer gemPidFileName: defaultPortOrResourceName.
      ServerFileDirectory
        splitName: fileName
        to: [ :dirPath :fileName | 
          | dir x |
          dir := ServerFileDirectory on: dirPath.
          self assert: (x := dir fileExists: fileName) == shouldExist ] ].
  ^ portCount