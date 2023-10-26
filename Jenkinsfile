pipeline {
  agent any
  stages {
    stage("build") {
        agent {
            // dockerfile true
            dockerfile {
              filename 'Dockerfile.afl01'
            }
        }
        steps {
          checkout([
              $class: 'GitSCM',
              branches: [[name: 'master']],
              extensions: [[$class: 'CloneOption', shallow: false, depth: 0, reference: '']],
              userRemoteConfigs: [[credentialsId:  'gh-ci', url: "https://github.com/jweyrich/imgify.git"]],
          ])         

          sh """
             /tmp/.scripts/patch.sh
          """

          sh """

             #make -j8 CFLAGS="-g -O0 -DFORTIFY_SOURCE=2 -Wall -fsanitize=address -fsanitize=pointer-compare -fsanitize=pointer-subtract -fsanitize=leak \
             #             -fsanitize-address-use-after-scope -fsanitize=unreachable -fsanitize=undefined -fcf-protection=full \
             #             -fstack-check -fstack-protector-all --coverage"
             
             make -j8 CC=afl-clang CFLAGS="-g -O0 -Wall -fprofile-instr-generate -fcoverage-mapping  \
                          -fstack-check -fstack-protector-all"
          """

          sh """
            mkdir -p ./.coverage
            /tmp/.scripts/setup_tests.sh           
          """

          // recordCoverage( tools: [[parser: "COBERTURA", pattern: "**/coverage*.xml"]],
          //                 id: "coverage-imgify",
          //                 name: "Coverage for imgify projectt",
          //                 sourceCodeRetention: "EVERY_BUILD",
          //                 sourceDirectories: [[path: "./"]]
          //                 )

          archiveArtifacts artifacts: '**/test/png/*.png, **/test/bin/*.bin, *.c, *.h, *.gcno, *.gcda, png2bin, bin2png'          
        }
    }    
  }
}
