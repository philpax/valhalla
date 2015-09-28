#!/bin/sh
set -e

mkdir -p build
cd build

# Build OS
nasm -felf32 ../src/boot.s -o boot.o
i686-elf-gcc -c ../src/main.c -m32 -o main.o -std=c99 -ffreestanding -O2 -Wall -Wextra
i686-elf-gcc -T ../src/linker.ld -m32 -o valhalla.bin -ffreestanding -O2 -nostdlib boot.o main.o

# Build ISO
mkdir -p iso/boot/grub
cp valhalla.bin iso/boot/valhalla.bin
cp ../src/grub.cfg iso/boot/grub/grub.cfg
grub-mkrescue -o valhalla.iso iso

cd ..