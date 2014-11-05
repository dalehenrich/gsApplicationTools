other
addGemServerOfClass: aServerClass withName: aUniqueName on: anArrayOfPortNumbers

	self addGemServer: (GemServer createServerOfClass: aServerClass withName: aUniqueName on: anArrayOfPortNumbers).
