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
             
             echo "patch memory leak in file.c line 309, 311"
             temp_file_name="\$(mktemp /tmp/foo.XXXXXXXXX)" && awk 'NR==309{print "\t\t\tmagic_close(magic);"}1' ./src/file.c > \$temp_file_name && mv -f \$temp_file_name ./src/file.c
             temp_file_name="\$(mktemp /tmp/foo.XXXXXXXXX)" && awk 'NR==312{print "\t\tmagic_close(magic);"}1' ./src/file.c > \$temp_file_name && mv -f \$temp_file_name ./src/file.c

             echo "patch buffer overflow in file.c line 199, 200, 201"
             temp_file_name="\$(mktemp /tmp/foo.XXXXXXXXX)" && \
                cat src/softmagic.c | \
                awk -v replacement="\t\twhile (magindex + 1 < nmagic &&" 'NR==199{\$0=replacement}{print}' | \
                awk -v replacement="\t\t    magic[magindex + 1].cont_level != 0) {" 'NR==200{\$0=replacement}{print}' | \
                awk -v replacement="\t\t\tm = &magic[++magindex];" 'NR==201{\$0=replacement}{print}' > \$temp_file_name && \
                mv -f \$temp_file_name ./src/softmagic.c


             echo "patch memory leak in tests/test.c line 101"
             temp_file_name="\$(mktemp /tmp/foo.XXXXXXXXX)" && \
                   cat ./tests/test.c | \
                   awk 'NR==106{print "\t\t\t\t\tfree(desired);"}1' |
                   awk 'NR==109{print "\t\t\tfree(desired);"}1' > \$temp_file_name && \
                   mv -f \$temp_file_name ./tests/test.c

             echo "compile \"file\" binary"
             make -j8 CFLAGS="-g -DFORTIFY_SOURCE=2 -Wall -fsanitize=address -fsanitize=pointer-compare -fsanitize=pointer-subtract -fsanitize=leak \
                          -fsanitize-address-use-after-scope -fsanitize=unreachable -fsanitize=undefined -fcf-protection=full \
                          -fstack-check -fstack-protector-all --coverage"

             echo "compile and invoke tests"
             make -C tests check CFLAGS="-g -DFORTIFY_SOURCE=2 -Wall -fsanitize=address -fsanitize=pointer-compare -fsanitize=pointer-subtract -fsanitize=leak \
                          -fsanitize-address-use-after-scope -fsanitize=unreachable -fsanitize=undefined -fcf-protection=full \
                          -fstack-check -fstack-protector-all --coverage"
          """

          archiveArtifacts artifacts: 'src/.libs/file, src/.libs/libmagic.so*'          
        }
    }    
  }
}
