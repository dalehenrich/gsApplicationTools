tasks
scheduleTimeInLondonTask
  ^ (GemServerRemoteTaskExample
    value: [ 
      true
        ifTrue: [ 
          | timeInLondon |
          "should extact the time from the html; not the most robust parsing algorithmn"
          timeInLondon := (HTTPSocket
            httpGet: 'http://www.time.org/zones/Europe/London.php')
            throughAll: 'Europe/London - ';
            upTo: Character space.
          '(from http://www.time.org), time in London is: ' , timeInLondon ] ])
    addToQueue: self