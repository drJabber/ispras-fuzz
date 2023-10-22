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
              args '--privileged -u 0:0'
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
             grep -rl 'openssl' ./ | xargs sed -i "s/\\([^a-zA-Z0-9_]\\)openssl\\([^a-zA-Z0-9_]\\)/\\1openssl1.0.2n\\2/g"
             ./configure
             make CFLAGS="-Wall -fsanitize=address -fsanitize=pointer-compare -fsanitize=pointer-subtract -fsanitize=leak \
                          -fsanitize-address-use-after-scope -fsanitize=unreachable -fsanitize=undefined -fcf-protection=full \
                          -fstack-check -fstack-protector-all --coverage"
          """

          sh "ls -lha ./tcpdump"        
          archiveArtifacts artifacts: '**/tcpdump'
        }
    }    
  }
}
