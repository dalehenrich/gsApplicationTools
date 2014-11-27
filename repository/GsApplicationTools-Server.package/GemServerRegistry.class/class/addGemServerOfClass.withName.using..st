registration
addGemServerOfClass: aServerClass withName: aUniqueName using: aGemServerClass
  self
    addGemServer:
      (aGemServerClass createServerOfClass: aServerClass withName: aUniqueName)