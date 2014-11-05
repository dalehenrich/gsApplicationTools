other
start: aServerClass named: aServerGemNameString onPorts: aPortNumberArray  delegate: aDelegate

	GemServerRegistry addGemServerOfClass: ZnServer withName: aServerGemNameString on: aPortNumberArray.
	(GemServerRegistry gemServerNamed: aServerGemNameString) delegate: aDelegate.
	   System commitTransaction.
	GemServerRegistry startGemServerNamed: aServerGemNameString
