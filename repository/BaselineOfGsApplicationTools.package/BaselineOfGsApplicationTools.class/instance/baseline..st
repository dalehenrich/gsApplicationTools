baseline
baseline: spec
  <baseline>
  spec
    for: #'common'
    do: [ 
      spec
        baseline: 'GLASS1'
          with: [ 
              spec
                loads: #('Base');
                repository: 'github://glassdb/glass:master/repository' ];
        yourself.
      spec
        package: 'GsApplicationTools-Server';
        package: 'GsApplicationTools-Test'
          with: [ spec requires: #('GsApplicationTools-Server') ];
        yourself.
      spec
        group: 'default' with: #('Core');
        group: 'Core' with: #('GsApplicationTools-Server');
        group: 'Tests' with: #('GsApplicationTools-Test');
        group: 'CI' with: #('Tests');
        yourself ]