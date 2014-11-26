other
ports
  ports == nil
    ifTrue: [ ports := self defaultPortList ].
  ^ ports