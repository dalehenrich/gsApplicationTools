launching
forkPortable: launchBlock
  "fork a portable process to evaluate launchBlock"

  | sem |
  sem := TransientSemaphore new.
  self singleton
    block: [ 
      launchBlock value.
      sem signal ].
  self singleton portableSemaphore signal.
  sem wait