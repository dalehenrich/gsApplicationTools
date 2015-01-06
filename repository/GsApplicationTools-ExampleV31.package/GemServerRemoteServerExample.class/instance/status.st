server compat
status
  | strm |
  strm := WriteStream on: String new.
  strm
    nextPutAll: 'Status for ' , self name printString;
    cr;
    nextPutAll: '---------------------';
    cr;
    tab;
    nextPutAll:
        'queue sequence: ' , self queueCounterValue printString , ' current sequence: '
            , self currentQueueCounter printString;
    cr;
    tab;
    nextPutAll: 'queue size: ' , self queue size printString;
    cr;
    tab;
    nextPutAll: 'inProcess size: ' , self inProcess size printString;
    cr;
    tab;
    nextPutAll: 'activeProcesses size: ' , self activeProcesses size printString;
    cr;
    yourself.
  ^ strm contents