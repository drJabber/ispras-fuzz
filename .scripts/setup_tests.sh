#!/bin/bash

mkdir -p ./test/png
mkdir -p ./test/bin

wget https://raw.githubusercontent.com/richgel999/random_pngs/main/random_pngs.7z -O ./test/png/test.7z

7z x ./test/png/test.7z -o./test/png -y
rm ./test/png/test.7z

echo "test png2bin"
pwd

test_pngs=(./test/png/*.png)
for png in ${test_pngs[@]:0:20}; 
do 
    LLVM_PROFILE_FILE="./.coverage/png2bin.profraw" ./png2bin -i $png -o ${png}".bin" -p 0 || true; 
done

/tmp/.scripts/radamsa --generators random -n 20 -o ./test/bin/test-%02n.bin

echo "test bin2png"
pwd

test_bins=(./test/bin/*.bin)
for bin in ${test_bins[@]:0:20}; 
do 
    LLVM_PROFILE_FILE="./.coverage/bin2png.profraw" ./bin2png -i $bin -o ${bin}".png" -p $(($RANDOM % 256)) || true; 
done

pwd
llvm-profdata merge -sparse ./.coverage/png2bin.profraw ./.coverage/bin2png.profraw -o ./.coverage/.profdata

