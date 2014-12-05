GemServer support of Zinc REST
-----------------

The following REST examples are base on using the **ZnExampleStorageRestServerDelegate**.
From the class comment:

```
I offer a REST interface on /storage with CRUD operations on JSON maps. 
I automatically use the call hierarchy below ZnExampleStorageRestCall.
```

To install Zinc REST support, evaluate the following in a tODE shell ([**smalltalk code**](#zinc-rest-installation)):

```Shell
project load --loads=REST --baseline \
        --repository=github://GsDevKit/zinc:issue_58/repository ZincHTTPComponents  
```

To browse the classes used in this example evaluate the following in a tODE shell:

```Shell
browse class --exact --hier ZnExampleStorageRestCall ZnExampleStorageRestServerDelegate \
       ZnAbstractExampleStorageRestServerDelegateTest ZnGemServer
```

Use the `mount` command:  

```Shell
mount /sys/stone/repos/gsApplicationTools/tode/ /home gemServerExample
cd /home/gemServerExample
```

to bring the `rest` script into your 

To register a REST GemServer execute the following in a tODE shell ([**smalltalk code**](#register-rest-gemserver)):

```Shell
./rest --register=rest --port=1720 --log=all --logTo=objectLog
```

The regisrtation command need only be issued once. Thereafter you can used the following to start/stop/restart a remote GemServer ([**smalltalk code**](#startstoprestart-gemserver)):

```Shell
./rest --start=rest
./rest --stop=rest
./rest --restart=rest
```

When you are done, you may use the following to unregister the GemServer ([**smalltalk code**](#unregister-gemserver]): 

```Shell
./rest --unregister=rest
```


```Shell
./rest
```

##Smalltalk Appendix

The following Smalltalk snippets are representative of the code that is executed by the tODE commands.

###Zinc REST Installation

The tODE command:

```Shell
project load --loads=REST --baseline \
        --repository=github://GsDevKit/zinc:issue_58/repository ZincHTTPComponents  
```

executes:

```Smalltalk
GsDeployer bulkMigrate: [
  Metacello new
    baseline: 'ZincHTTPComponents';
    repository: 'github://GsDevKit/zinc:issue_58/repository';
    load: 'REST' ].
```

###Register REST GemServer

The tODE command:

```Shell
./rest --register=rest --port=1720 --log=all --logTo=objectLog
```

executes: 
```Smalltalk
(ZnGemServer register: 'rest')
    ports: #(1720);
    logFilter: nil;
    logToObjectLog;
    delegate: ZnExampleStorageRestServerDelegate new;
    register.
```

###Start/Stop/Restart GemServer

The tODE command:

```Shell
./rest --start=rest
./rest --stop=rest
./rest --restart=rest
```

executes:

```Smalltalk
(GemServerRegistry gemServerNamed: 'rest') startGems.
(GemServerRegistry gemServerNamed: 'rest') stopGems.
(GemServerRegistry gemServerNamed: 'rest') restartGems.
```

###Unregister GemServer

The tODE command:

```Shell
./rest --unregister=rest
```

executes:

```Smalltalk
(GemServerRegistry gemServerNamed: 'rest') unregister.
```

