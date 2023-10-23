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
              branches: [[name: 'resf/tags/0.4']],
              extensions: [[$class: 'CloneOption', shallow: false, depth: 0, reference: '']],
              userRemoteConfigs: [[credentialsId:  'gh-ci', url: "https://github.com/kermitt2/pdfalto.git"]],
          ])         

          sh """
              ./install_deps.sh
              cmake .
              make
          """

          archiveArtifacts artifacts: '**/pdfalto'          
        }
    }    
  }
}
