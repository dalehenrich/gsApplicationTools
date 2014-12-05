GemServer support of Zinc REST
-----------------

The following REST examples are base on using the **ZnExampleStorageRestServerDelegate** from the class commet:

```
I offer a REST interface on /storage with CRUD operations on JSON maps. 
I automatically use the call hierarchy below ZnExampleStorageRestCall.
```

## GemStone Installation

To [install Zinc REST support](#zinc-rest-installation), evaluate the following in a tODE shell:

```Shell
project load --loads=REST --baseline --repository=github://GsDevKit/zinc:issue_58/repository ZincHTTPComponents  
```

To browse the classes used in this example evaluate the following in a tODE shell:

```Shell
browse class --exact --hier ZnExampleStorageRestCall ZnExampleStorageRestServerDelegate ZnAbstractExampleStorageRestServerDelegateTest ZnGemServer
```

To [register a REST GemServer](#register-rest-gemserver) execute the following in a tODE shell:

```Shell
./rest --register=rest --port=1720 --log=all --logTo=objectLog
```

The regisrtation command need only be issued once. Thereafter you can used the following to [start/stop/restart](#start-stop-restart-gemserver) a remote GemServer:

```Shell
./rest --start=rest
./rest --stop=rest
./rest --restart=rest
```

The remote GemServer is started a *topaz* instance using the [*startGemServerGem* script](https://github.com/GsDevKit/gsApplicationTools/blob/master/bin/startGemServerGem) found in the *bin* directory of the gsApplicationTools git clone.

When you are done, you may use the following to unregister the GemServer: 

```Shell
./rest --unregister=rest
```


```Shell
./rest
```

##Smalltalk Workspaces

###Zinc REST Installation

```Smalltalk
Metacello new
  baseline: 'ZincHTTPComponents';
  repository: 'github://GsDevKit/zinc:issue_58/repository';
  load: 'REST'.
```

###Register REST GemServer

```Smalltalk
(ZnGemServer register: 'rest')
    ports: #(1720);
    logFilter: nil;
    logToObjectLog;
    delegate: ZnExampleStorageRestServerDelegate new;
    register.
```

###Start/Stop/Restart GemServer

```Smalltalk
(GemServerRegistry gemServerNamed: 'rest') startGems.
(GemServerRegistry gemServerNamed: 'rest') stopGems.
(GemServerRegistry gemServerNamed: 'rest') restartGems.
```

###Unregister GemServer

```Smalltalk
(GemServerRegistry gemServerNamed: 'rest') unregister.
```

