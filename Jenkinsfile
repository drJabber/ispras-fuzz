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

             echo "patch buffer overflow in file.c line 199, 200"
             temp_file_name="\$(mktemp /tmp/foo.XXXXXXXXX)" && \
                cat src/softmagic.c | \
                awk -v replacement="\t\twhile (magindex + 1 < nmagic \&\&" 'NR==199{\$0=replacement}{print}' | \
                awk -v replacement="\t\t    magic[magindex + 1].cont_level != 0) {" 'NR==200{\$0=replacement}{print}' > stemp_file_name && \
                mv -f \$temp_file_name ./src/softmagic.c

             make -j8 CFLAGS="-g -DFORTIFY_SOURCE=2 -Wall -fsanitize=address -fsanitize=pointer-compare -fsanitize=pointer-subtract -fsanitize=leak \
                          -fsanitize-address-use-after-scope -fsanitize=unreachable -fsanitize=undefined -fcf-protection=full \
                          -fstack-check -fstack-protector-all --coverage"

             make -C tests check CFLAGS="-g -DFORTIFY_SOURCE=2 -Wall -fsanitize=address -fsanitize=pointer-compare -fsanitize=pointer-subtract -fsanitize=leak \
                          -fsanitize-address-use-after-scope -fsanitize=unreachable -fsanitize=undefined -fcf-protection=full \
                          -fstack-check -fstack-protector-all --coverage"
          """

          sh "ls -lha ./"        
          archiveArtifacts artifacts: '**/file'          
        }
    }    
  }
}
