registration
addGemServerOfClass: aServerClass withName: aUniqueName on: anArrayOfPortNumbers using: aGemServerClass
  ^ self
    addGemServer:
      (aGemServerClass
        createServerOfClass: aServerClass
        withName: aUniqueName
        on: anArrayOfPortNumbers)