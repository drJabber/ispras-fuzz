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

             echo "patch to debug"
             temp_file_name="\$(mktemp /tmp/foo.XXXXXXXXX)" && awk 'NR==146{print "\tprintf(\\"DEBUG height %d, width %d, channels %d, rowbytes %d, pad_byte %u, ver %s, data_size %d, last_row-data %u \\\\n\\", height, width, channels, rowbytes, pad_byte, PNG_LIBPNG_VER_STRING, data_size, (uint32_t)(last_row-data));"}1' ./imgify.c > \$temp_file_name && mv -f \$temp_file_name ./imgify.c
             temp_file_name="\$(mktemp /tmp/foo.XXXXXXXXX)" && awk 'NR==150{print "\tprintf(\\"DEBUG last_row-data+column-1 %u \\\\n\\", (uint32_t)(last_row-data+column-1));"}1' ./imgify.c > \$temp_file_name && mv -f \$temp_file_name ./imgify.c
   
             temp_file_name="\$(mktemp /tmp/foo.XXXXXXXXX)" && \
                cat ./imgify.c | \
                awk -v replacement="\tuint8_t *data = malloc(data_size);" 'NR==117{\$0=replacement}{print}'  > \$temp_file_name && \
                mv -f \$temp_file_name ./imgify.c


             #make -j8 CFLAGS="-g -DFORTIFY_SOURCE=2 -Wall -fsanitize=address -fsanitize=pointer-compare -fsanitize=pointer-subtract -fsanitize=leak \
             #             -fsanitize-address-use-after-scope -fsanitize=unreachable -fsanitize=undefined -fcf-protection=full \
             #             -fstack-check -fstack-protector-all --coverage"

             make -j8 CFLAGS="-g -Wall -fprofile-instr-generate -fcoverage-mapping  \
                          -fsanitize=address -fsanitize=pointer-compare -fsanitize=pointer-subtract -fsanitize=leak \
                          -fsanitize-address-use-after-scope -fsanitize=unreachable -fsanitize=undefined -fcf-protection=full \
                          -fstack-check -fstack-protector-all"
          """

          sh """
            mkdir -p ./.coverage
            /tmp/.scripts/setup_tests.sh           
          """

          recordCoverage( tools: [[parser: "COBERTURA", pattern: "**/coverage*.xml"]],
                          id: "coverage-imgify",
                          name: "Coverage for imgify projectt",
                          sourceCodeRetention: "EVERY_BUILD",
                          sourceDirectories: [[path: "./"]]
                          )

          archiveArtifacts artifacts: 'test, *.c, *.h, *.gcno, *.gcda, png2bin, bin2png'          
        }
    }    
  }
}
