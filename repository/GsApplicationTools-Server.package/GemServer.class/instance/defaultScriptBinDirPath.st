server specialization
defaultScriptBinDirPath
  | wc fileTreeRepo |
  MCWorkingCopy registry
    do: [ :mgr | 
      (mgr packageInfo includesClass: GemServer)
        ifTrue: [ wc := mgr ] ].
  wc ifNil: [ ^ self error: 'GemServer script bin dir not foiund' ].
  fileTreeRepo := (wc repositoryGroup repositories
    reject: [ :repo | MCCacheRepository default = repo ])
    detect: [ :repo | repo isKindOf: MCFileTreeRepository ].
  ^ (fileTreeRepo directory containingDirectory directoryNamed: 'bin')
    pathString