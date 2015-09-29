#!/bin/sh
set -e

mkdir -p build

# Build OS
nasm -felf32 src/boot.s -o build/boot.o
crystal build src/main.cr -o build/main --cross-compile "none x86" --target "i686-none-elf" --mcpu i686 --release --prelude "std" --link-flags "-m32 -nostdlib"
i686-elf-ld -T src/linker.ld -o build/valhalla.bin build/boot.o build/main.o

# Build ISO
cd build

mkdir -p iso/boot/grub
cp valhalla.bin iso/boot/valhalla.bin
cp ../src/grub.cfg iso/boot/grub/grub.cfg
echo "Hello, world!" > iso/hello_world.txt
grub-mkrescue -o valhalla.iso iso

cd ..