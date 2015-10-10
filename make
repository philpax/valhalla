#!/bin/bash
set -e

rm -rf build
mkdir build

# Build OS
nasm -felf32 src/boot.s -g -o build/boot.o
nasm -felf32 src/gdt.s -g -o build/gdt.o
nasm -felf32 src/cpuid.s -g -o build/cpuid.o
nasm -felf32 src/idt.s -g -o build/idt.o
nasm -felf32 src/io.s -g -o build/io.o
crystal build src/main.cr -o build/main --cross-compile "none x86" --target "i686-none-elf" --mcpu i686 --debug --release --prelude "std" --link-flags "-m32 -nostdlib"
i686-elf-ld -T src/linker.ld -o build/valhalla.bin build/*.o
nm build/valhalla.bin | grep " T " | awk '{ print $1" "$3 }' > build/valhalla.sym
objcopy --strip-debug build/valhalla.bin

# Build tools
crystal build src/tools/vfs_make.cr -o build/vfs_make

# Build ISO
cd build
mkdir -p iso

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