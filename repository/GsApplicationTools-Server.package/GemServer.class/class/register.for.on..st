registration
register: aName for: aServerClass on: anArrayOfPortNumbers
  | server |
  server := self
    createServerOfClass: aServerClass
    withName: aName
    on: anArrayOfPortNumbers.
  GemServerRegistry addGemServer: server.
  ^ server