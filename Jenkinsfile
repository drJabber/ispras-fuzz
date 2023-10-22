pipeline {
  agent any
  stages {
    stage("build") {
        agent {
            // dockerfile true
            dockerfile {
              filename 'Dockerfile.dev01'
              args '--privileged -u 0:0'
            }
        }
        steps {
          checkout([
              $class: 'GitSCM',
              branches: [[name: 'refs/tags/FILE5_10']],
              extensions: [[$class: 'CloneOption', shallow: false, depth: 0, reference: '']],
              userRemoteConfigs: [[credentialsId:  'gh-ci', url: "https://github.com/file/file.git"]],
          ])         

          sh """
             autoreconf -f -i
             ./configure --disable-silent-rules

             awk 'NR==309{print "\t\t\tmagic_close(magic);"}1' src/file.c > src/file.c

             make -j8 CFLAGS="-g -DFORTIFY_SOURCE=2 -Wall -fsanitize=address -fsanitize=pointer-compare -fsanitize=pointer-subtract -fsanitize=leak \
                          -fsanitize-address-use-after-scope -fsanitize=unreachable -fsanitize=undefined -fcf-protection=full \
                          -fstack-check -fstack-protector-all --coverage"
          """

          sh "ls -lha ./"        
          archiveArtifacts artifacts: '**/file'          
        }
    }    
  }
}
