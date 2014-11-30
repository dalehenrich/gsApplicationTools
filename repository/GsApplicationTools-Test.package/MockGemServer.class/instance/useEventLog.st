accessing
useEventLog
  useEventLog ifNil: [ useEventLog := true ].
  ^ useEventLog