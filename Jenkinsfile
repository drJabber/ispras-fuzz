pipeline {
  agent any
  stages {
    stage("build") {
        agent {
            // dockerfile true
            dockerfile {
              filename 'Dockerfile.cov01'
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
             rm *.gcno *.gcda || true

             echo "patch defines"
             temp_file_name="\$(mktemp /tmp/foo.XXXXXXXXX)" && \
                cat ./png2bin.c | \
                awk -v replacement="" 'NR==30{\$0=replacement}{print}' | 
                awk -v replacement='#include \"common_options.h\"' 'NR==34{\$0=replacement}{print}' > \$temp_file_name && \
                mv -f \$temp_file_name ./png2bin.c

             echo "patch defines"
             temp_file_name="\$(mktemp /tmp/foo.XXXXXXXXX)" && \
                cat ./bin2png.c | \
                awk -v replacement="" 'NR==30{\$0=replacement}{print}' | 
                awk -v replacement='#include \"common_options.h\"' 'NR==34{\$0=replacement}{print}' > \$temp_file_name && \
                mv -f \$temp_file_name ./bin2png.c

             echo "fix double free in imgify.c 253"
             temp_file_name="\$(mktemp /tmp/foo.XXXXXXXXX)" && \
                cat ./imgify.c | \
                awk -v replacement="" 'NR==253{\$0=replacement}{print}'  > \$temp_file_name && \
                mv -f \$temp_file_name ./imgify.c


             #make -j8 CFLAGS="-g -DFORTIFY_SOURCE=2 -Wall -fsanitize=address -fsanitize=pointer-compare -fsanitize=pointer-subtract -fsanitize=leak \
             #             -fsanitize-address-use-after-scope -fsanitize=unreachable -fsanitize=undefined -fcf-protection=full \
             #             -fstack-check -fstack-protector-all --coverage"

             make -j8 CFLAGS="-g -Wall --coverage"
          """

          sh """
            /tmp/.scripts/setup_tests.sh
            
            mkdir -p ./.coverage
            lcov -c -d . -o ./.coverage/imgify_cov.data
            which gcov
            gcov --version
            gcovr -x ./.coverage/coverage.xml
          """

          // discoverGitReferenceBuild
          recordCoverage( tools: [[parser: "Cobertura"]],
                          id: "coverage",
                          sourceCodeRetention: "EVERY_BUILD",
                          sourceDirectories: [["./"]]
                          )

          archiveArtifacts artifacts: 'test, *.c, *.h, *.gcno, *.gcda, png2bin, bin2png'          
        }
    }    
  }
}
