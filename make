#!/bin/bash
set -e

mkdir -p build

# Build OS
nasm -felf32 src/boot.s -o build/boot.o
crystal build src/main.cr -o build/main --cross-compile "none x86" --target "i686-none-elf" --mcpu i686 --release --prelude "std" --link-flags "-m32 -nostdlib"
i686-elf-ld -T src/linker.ld -o build/valhalla.bin build/boot.o build/main.o

# Build tools
crystal build src/tools/vfs_make.cr -o build/vfs_make

# Build ISO
cd build

# Build VFS
mkdir -p vfs
echo -n "Hello, world!" > vfs/hello_world.txt
echo -n "Goodbye, world!" > vfs/goodbye_world.txt
./vfs_make vfs iso/vfs.bin

# Assemble final ISO
mkdir -p iso/boot/grub
cp valhalla.bin iso/boot/valhalla.bin
cp ../src/grub.cfg iso/boot/grub/grub.cfg
grub-mkrescue -o valhalla.iso iso

cd ..