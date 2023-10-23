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
              branches: [[name: 'refs/tags/0.4']],
              extensions: [[$class: 'CloneOption', shallow: false, depth: 0, reference: '']],
              userRemoteConfigs: [[credentialsId:  'gh-ci', url: "https://github.com/kermitt2/pdfalto.git"]],
          ])         

          sh """
             echo "patch git modules"

             temp_file_name="\$(mktemp /tmp/foo.XXXXXXXXX)" && \
                cat ./.git/config | \
                awk -v replacement="\turl = https://github.com/kermitt2/xpdf-4.03.git" 'NR==12{\$0=replacement}{print}' > \$temp_file_name && \
                mv -f \$temp_file_name ./.git/config

              git submodule update --init --recursive

              ./install_deps.sh
              cmake .
              make
          """

          archiveArtifacts artifacts: '**/pdfalto'          
        }
    }    
  }
}
