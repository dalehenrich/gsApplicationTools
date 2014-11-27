instance creation
createServerOfClass: aServerClass withName: aName
  ^ self new
    serverClass: aServerClass;
    name: aName;
    yourself