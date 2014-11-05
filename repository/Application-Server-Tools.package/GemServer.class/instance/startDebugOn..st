other
startDebugOn: port

	(self serverClass on: port) 
		delegate: self delegate;
        debugMode: true;
	start.

	 [ true ] whileTrue: [ (Delay forSeconds: 10) wait ]
