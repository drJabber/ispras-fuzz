#!/bin/bash

mkdir -p ./test/png
mkdir -p ./test/bin

wget https://raw.githubusercontent.com/richgel999/random_pngs/main/random_pngs.7z -O ./test/png/test.7z

7z x ./test/png/test.7z -o./test/png -y
rm ./test/png/test.7z

echo "test png2bin"

test_pngs=(./test/png/*.png)
for png in ${test_pngs[@]:0:20}; 
do 
    LLVM_PROFILE_FILE="./.coverage/png2bin-%p.profraw" ./png2bin -i $png -o ${png}".bin" -p 0 || true; 
done


echo "test bin2png"
/tmp/.scripts/radamsa --generators random -n 30 -o ./test/bin/test-%02n.bin
test_bins=(./test/bin/*.bin)
for bin in ${test_bins[@]:0:30}; 
do 
    LLVM_PROFILE_FILE="./.coverage/bin2png-%p.profraw" ./bin2png -i $bin -o ${bin}".png" -p $(($RANDOM % 300)) || true; # 300>256, so paths with -p errors also will be covered
done

ls ./.coverage/*profraw
test_pngs=`find ./.coverage/*profraw -maxdepth 1 -type f -not -path '*/\.*'`
echo $test_pngs

llvm-profdata merge -sparse $test_pngs -o ./.coverage/imgify.profdata
llvm-cov export ./png2bin -instr-profile=./.coverage/imgify.profdata -format=lcov > ./.coverage/imgify.png2bin.lcov
llvm-cov export ./bin2png -instr-profile=./.coverage/imgify.profdata -format=lcov > ./.coverage/imgify.bin2png.lcov
lcov_cobertura ./.coverage/imgify.png2bin.lcov -b ./ -o ./.coverage/coverage-imgify-png2bin.xml
lcov_cobertura ./.coverage/imgify.bin2png.lcov -b ./ -o ./.coverage/coverage-imgify-bin2png.xml
