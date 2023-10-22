pipeline {
  agent any
  stages {
    stage("build") {
        agent {
            // dockerfile true
            dockerfile {
              filename 'Dockerfile.rel01'
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
             make -j8
          """

          sh "ls -lha ./"        
          archiveArtifacts artifacts: '**/file'          
        }
    }    
  }
}
