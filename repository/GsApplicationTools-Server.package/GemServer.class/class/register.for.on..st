registration
register: aName for: aServerClass on: anArrayOfPortNumbers
  ^ (self
    createServerOfClass: aServerClass
    withName: aName
    on: anArrayOfPortNumbers)
    register;
    yourself