#!/bin/bash
set -e

rm -rf build
mkdir build

# Build OS
for file in src/*.s
do
    nasm -felf32 $file -g -o build/$(basename $file).o
done
crystal build src/main.cr -o build/main --cross-compile "none x86" --target "i686-none-elf" --mcpu i686 --release --prelude "std" --link-flags "-m32 -nostdlib"
i686-elf-ld -T src/linker.ld -o build/valhalla.bin build/*.o
nm build/valhalla.bin | grep " T " | awk '{ print $1" "$3 }' > build/valhalla.sym
objcopy --strip-debug build/valhalla.bin

# Build tools
crystal build src/tools/keymap_make.cr -o build/keymap_make
crystal build src/tools/vfs_make.cr -o build/vfs_make

# Build ISO
cd build
mkdir -p iso

# Build VFS
mkdir -p vfs
./keymap_make vfs/keymap
echo -n "Hello, world!" > vfs/hello_world.txt
echo -n "Goodbye, world!" > vfs/goodbye_world.txt
./vfs_make vfs iso/vfs.bin

# Assemble final ISO
mkdir -p iso/boot/grub
cp valhalla.bin iso/boot/valhalla.bin
cp ../src/grub.cfg iso/boot/grub/grub.cfg
grub-mkrescue -o valhalla.iso iso

cd ..
