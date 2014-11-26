other
start: aServerClass named: aServerGemNameString onPorts: aPortNumberArray
  GemServerRegistry
    addGemServerOfClass: aServerClass
    withName: aServerGemNameString
    on: aPortNumberArray.
  System commitTransaction.
  GemServerRegistry startGemServerNamed: aServerGemNameString