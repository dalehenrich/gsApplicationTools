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
        package: 'Application-Server-Tools';
        yourself.
      spec
        group: 'default' with: #('Core');
        group: 'Core' with: #('Application-Server-Tools');
        group: 'Tests' with: #('default');
        yourself ]