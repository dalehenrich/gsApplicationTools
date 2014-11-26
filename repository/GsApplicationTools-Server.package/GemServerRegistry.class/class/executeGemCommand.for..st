other
executeGemCommand: command for: server

	| commandLine |
	Transcript cr; show: '---', command, ' server gems', ' ('; show: TimeStamp now printString; show: ')'.
	commandLine := 
		(GsFile _expandEnvVariable: 'GEMSTONE_STONE_DIR' isClient: false), 
		'/tools/runSmalltalkServerGem ', 
		command, 
		' ', 
		server name,
		' ', 
		server portString.
	Transcript cr; show: (System performOnServer: commandLine) withSqueakLineEndings.
	Transcript cr; show: '---Finished server gems ', command, ' ('; show: TimeStamp now printString; show: ')'.
