other
start: aServerClass named: aServerGemNameString onPorts: aPortNumberArray 

	GemServerRegistry addServerOfClass: aServerClass withName: aServerGemNameString on: aPortNumberArray.
    System commitTransaction.
	GemServerRegistry startServerNamed: aServerGemNameString.
