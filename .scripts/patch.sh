#!/bin/sh
             rm *.gcno *.gcda || true

             echo "patch defines"
             temp_file_name="$(mktemp /tmp/foo.XXXXXXXXX)" && \
                cat ./png2bin.c | \
                awk -v replacement="" 'NR==30{$0=replacement}{print}' | 
                awk -v replacement='#include "common_options.h"' 'NR==34{$0=replacement}{print}' > $temp_file_name && \
                mv -f $temp_file_name ./png2bin.c

             echo "patch defines"
             temp_file_name="$(mktemp /tmp/foo.XXXXXXXXX)" && \
                cat ./bin2png.c | \
                awk -v replacement="" 'NR==30{$0=replacement}{print}' | 
                awk -v replacement='#include "common_options.h"' 'NR==34{$0=replacement}{print}' > $temp_file_name && \
                mv -f $temp_file_name ./bin2png.c

             echo "fix double free in imgify.c 253"
             temp_file_name="$(mktemp /tmp/foo.XXXXXXXXX)" && \
                cat ./imgify.c | \
                awk -v replacement="" 'NR==253{$0=replacement}{print}'  > $temp_file_name && \
                mv -f $temp_file_name ./imgify.c

             echo "patch to debug"
             temp_file_name="$(mktemp /tmp/foo.XXXXXXXXX)" && awk 'NR==146{print "\tprintf(\"DEBUG height %d, width %d, channels %d, rowbytes %d, pad_byte %u, ver %s, data_size %d, last_row-data %u \", height, width, channels, rowbytes, pad_byte, PNG_LIBPNG_VER_STRING, data_size, (uint32_t)(last_row-data));"}1' ./imgify.c > $temp_file_name && mv -f $temp_file_name ./imgify.c
             temp_file_name="$(mktemp /tmp/foo.XXXXXXXXX)" && awk 'NR==150{print "\tprintf(\"DEBUG last_row-data+column-1 %u \n\", (uint32_t)(last_row-data+column-1));"}1' ./imgify.c > $temp_file_name && mv -f $temp_file_name ./imgify.c
   
             temp_file_name="$(mktemp /tmp/foo.XXXXXXXXX)" && \
                cat ./imgify.c | \
                awk -v replacement="\tuint8_t *data = malloc(data_size);" 'NR==117{$0=replacement}{print}'  > $temp_file_name && \
                mv -f $temp_file_name ./imgify.c


             echo "patch to afl"
             temp_file_name="$(mktemp /tmp/foo.XXXXXXXXX)" && \
                cat ./Makefile | \
                awk -v replacement="\tafl-clang -o \$@ -c imgify.c \$(CFLAGS);" 'NR==18{\$0=replacement}{print}'  > $temp_file_name && \
                mv -f $temp_file_name ./Makefile

             echo "patch to afl"
             temp_file_name="$(mktemp /tmp/foo.XXXXXXXXX)" && \
                cat ./Makefile | \
                awk -v replacement="\tafl-clang -o \$@ -c imgify.c \$(CFLAGS);" 'NR==21{\$0=replacement}{print}'  > $temp_file_name && \
                mv -f $temp_file_name ./Makefile

             temp_file_name="$(mktemp /tmp/foo.XXXXXXXXX)" && \
                cat ./Makefile | \
                awk -v replacement='\tafl-clang -o \$@ bin2png.c $^ \$(CFLAGS) \$(LDFLAGS)' 'NR==24{\$0=replacement}{print}'  > $temp_file_name && \
                mv -f $temp_file_name ./Makefile

             temp_file_name="$(mktemp /tmp/foo.XXXXXXXXX)" && \
                cat ./Makefile | \
                awk -v replacement='\tafl-clang -o \$@ bin2png.c $^ \$(CFLAGS) \$(LDFLAGS)' 'NR==27{\$0=replacement}{print}'  > $temp_file_name && \
                mv -f $temp_file_name ./Makefile
