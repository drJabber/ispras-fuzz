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
          checkout([
              $class: 'GitSCM',
              branches: [[name: 'refs/tags/tcpdump-4.5.0']],
              extensions: [[$class: 'CloneOption', shallow: false, depth: 0, reference: '']],
              userRemoteConfigs: [[credentialsId:  'gh-ci', url: "https://github.com/the-tcpdump-group/tcpdump.git"]],
          ])         
          // git branch: "refs/tags/tcpdump-4.5.0", credentialsId: "gh-ci", url: "https://github.com/the-tcpdump-group/tcpdump.git"

          sh """
             grep -rl 'openssl' ./ | xargs sed -i "s/\([^a-zA-Z0-9]\)openssl\([^a-zA-Z0-9]\)/\1openssl1.0.2n\2/g"
             ./configure
             make 
             make check
          """
        }
    }    
  }
}
