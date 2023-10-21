pipeline {
  agent any
  stages {
    stage("build") {
        agent {
            // dockerfile true
            dockerfile {
              filename 'Dockerfile.rel01'
              // dir 'build'
              // label 'my-defined-label'
              // additionalBuildArgs  '--build-arg version=1.0.2'
              // args '-v /tmp:/tmp'
              args '--cap-add=NET_ADMIN --cap-add=NET_RAW'
            }
        }
        steps {
          checkout([
              $class: 'GitSCM',
              branches: [[name: 'refs/tags/tcpdump-4.5.0']],
              extensions: [[$class: 'CloneOption', shallow: false, depth: 0, reference: '']],
              userRemoteConfigs: [[credentialsId:  'gh-ci', url: "https://github.com/the-tcpdump-group/tcpdump.git"]],
          ])         

          sh """
             pwd
             grep -rl 'openssl' ./ | xargs sed -i "s/\\([^a-zA-Z0-9_]\\)openssl\\([^a-zA-Z0-9_]\\)/\\1openssl1.0.2n\\2/g"
             ./configure
             make CFLAGS="-fsanitize=address -fsanitize=leak -fsanitize=undefined -fsanitize=unreachable "

             timeout 20s ./tcpdump
          """
        }
    }    
  }
}
