gem server registration
register: aName for: aServerClass on: anArrayOfPortNumbersOrResourceNames
  ^ (self
    createServerOfClass: aServerClass
    withName: aName
    on: anArrayOfPortNumbersOrResourceNames)
    register;
    yourself