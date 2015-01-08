instance creation
createServerOfClass: aServerClass withName: aName on: anArrayOfPortNumbersOrResourceNames
  ^ self new
    serverClass: aServerClass;
    name: aName;
    portOrResourceNameList: anArrayOfPortNumbersOrResourceNames;
    yourself