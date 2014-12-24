tasks
scheduleBreakpointTask
  ^ (GemServerRemoteTaskExample
    value: [ 
      | meth |
      meth := self class compiledMethodAt: #'breakpointMethod'.
      meth setBreakAtStepPoint: 1.
      GsProcess usingNativeCode
        ifTrue: [ 
          | p |
          p := GsProcess _current.
          [ p convertToPortableStack ] fork.
          Processor yield ].
      Breakpoint trappable: true.
      self breakpointMethod ])
    addToQueue: self