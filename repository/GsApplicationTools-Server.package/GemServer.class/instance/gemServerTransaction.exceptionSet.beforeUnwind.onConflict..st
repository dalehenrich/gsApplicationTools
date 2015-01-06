gem server api
gemServerTransaction: aBlock exceptionSet: exceptionSet beforeUnwind: beforeUnwindBlock onConflict: conflictBlock
  ^ self
    gemServerTransaction: aBlock
    exceptionSet: exceptionSet
    beforeUnwind: beforeUnwindBlock
    ensure: [  ]
    onConflict: conflictBlock