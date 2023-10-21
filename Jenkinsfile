pipeline {
  agent any
  stages {
    stage("build") {
        agent {
            dockerfile true
            // {
              // filename 'Dockerfile.build'
              // dir 'build'
              // label 'my-defined-label'
              // additionalBuildArgs  '--build-arg version=1.0.2'
              // args '-v /tmp:/tmp'
            // }
        }
        steps {
          echo "hello from docker!"
        }
    }    
  }
}
