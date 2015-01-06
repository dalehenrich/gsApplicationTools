gem server api
gemServerTransaction: aBlock exceptionSet: exceptionSet beforeUnwind: beforeUnwindBlock
  ^ self
    gemServerTransaction: aBlock
    exceptionSet: exceptionSet
    beforeUnwind: beforeUnwindBlock
    ensure: [  ]