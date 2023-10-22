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
              branches: [[name: 'refs/tags/tcpdump-4.5.0']],
              extensions: [[$class: 'CloneOption', shallow: false, depth: 0, reference: '']],
              userRemoteConfigs: [[credentialsId:  'gh-ci', url: "https://github.com/the-tcpdump-group/tcpdump.git"]],
          ])         

          sh """
             grep -rl 'openssl' ./ | xargs sed -i "s/\\([^a-zA-Z0-9_]\\)openssl\\([^a-zA-Z0-9_]\\)/\\1openssl1.0.2n\\2/g"
             ./configure
             make 
          """

          sh "ls -lha ./tcpdump"        
          archiveArtifacts artifacts: '**/tcpdump'          
        }
    }    
  }
}
