#!/bin/bash

mkdir -p ./test/png
mkdir -p ./test/bin

wget https://raw.githubusercontent.com/richgel999/random_pngs/main/random_pngs.7z -O ./test/png/test.7z

7z x ./test/png/test.7z -o./test/png -y
rm ./test/png/test.7z

test_pngs = (./test/png/*.png)
for png in ${test_pngs[@]:0:20}; 
do 
    ./png2bin -i $png -o ${png}".bin" -p 0; 
done
