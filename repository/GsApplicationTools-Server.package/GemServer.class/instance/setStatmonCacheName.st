service instance-private
setStatmonCacheName
  "set _cacheName: for Gem to get unique id in statmon output. see http://code.google.com/p/glassdb/issues/detail?id=132"

  | x cacheName |
  cacheName := (x := self name , '-'
    , (GsSession serialOfSession: System session) printString , '-'
    , System myUserProfile userId) copyFrom: 1 to: (x size min: 31).
  self scriptLogEvent: 'setStatmonCacheName: ' , self name object: cacheName.
  System _cacheName: cacheName