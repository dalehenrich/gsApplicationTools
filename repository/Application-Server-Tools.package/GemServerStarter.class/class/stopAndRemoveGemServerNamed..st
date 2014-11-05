other
stopAndRemoveGemServerNamed: aServerGemNameString

	GemServerRegistry stopGemsNamed: aServerGemNameString.
	GemServerRegistry removeGemServerNamed: aServerGemNameString.
    System commitTransaction
