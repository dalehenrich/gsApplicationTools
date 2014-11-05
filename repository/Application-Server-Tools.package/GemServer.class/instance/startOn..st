other
startOn: port

	(self serverClass on: port) 
		delegate: self delegate;
        debugMode: false;
	start.

	 [ true ] whileTrue: [ (Delay forSeconds: 10) wait ]
