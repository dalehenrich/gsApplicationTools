gem server api
gemServer: aBlock exceptionSet: exceptionSet beforeUnwind: beforeUnwindBlock
  ^ self
    gemServer: aBlock
    exceptionSet: exceptionSet
    beforeUnwind: beforeUnwindBlock
    ensure: [  ]