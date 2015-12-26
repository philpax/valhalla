# Valhalla
A basic proof-of-concept kernel written in Crystal.

## Prerequisites
In order to build the kernel, a number of prerequisites are required:

* *Crystal (0.9.0 onwards)*: Required to build the majority of the code. The code is largely limited to newer versions of Crystal, so more recent versions are preferred.
* *nasm*: Required for building the assembly code, where appropriate.
* *i686-elf-ld*: Required for linking together the resulting object files. As we're cross-compiling, life is much easier with a platform-appropriate linker. Such a linker can be built using the binutils section of the following guide: http://wiki.osdev.org/GCC_Cross-Compiler#The_Build
* *grub-mkrescue*: Required to build an ISO with GRUB2 pre-installed
* *qemu(-system-i386)*: Optional: used to run the ISO, as through the run script

## Building
For now, simply run `./make` after the prerequisites have been installed. This will do a number of things:

1. Make a `build` folder.
2. Build all of the required assembly files.
3. Build all of the Crystal files.
4. Link together the object files to produce `valhalla.bin`.
5. Extract the symbols from `valhalla.bin` into `valhalla.sym`, and then strip `valhalla.bin` of its symbols.
6. Build `vfs_make`.
7. Build the VFS module using `vfs_make` from the contents of the `vfs` folder.
8. Assemble a boot disk, then use `grub-mkrescue` to create an ISO image with GRUB2 pre-installed.

## Running
A `./run` script has been provided for emulation use which assumes `qemu-system-i386` is available.

To run the OS for testing, use `./run`.
To run the OS for debugging, use `./run debug`, which allows the use of the GDB remote bridge.
