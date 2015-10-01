MBALIGN     equ  1<<0
MEMINFO     equ  1<<1
FLAGS       equ  MBALIGN | MEMINFO
MAGIC       equ  0x1BADB002
CHECKSUM    equ -(MAGIC + FLAGS)

section .multiboot
align 4
	dd MAGIC
	dd FLAGS
	dd CHECKSUM

section .bootstrap_stack, nobits
align 4
stack_bottom:
	resb 16384
stack_top:

section .text

; Start-up, and loop
global _start
global halt

_start:
	mov esp, stack_top

	extern kmain
	push ebx
	call kmain
halt:
	cli
	hlt
	jmp halt

; Useful functions
global dummy
dummy:
	ret

; GDT manipulation
gdtr dw 0 ; GDT entry count
	 dd 0 ; GDT entries location

global load_gdt
load_gdt:
	mov eax, [esp + 4]
	mov [gdtr + 2], eax
	mov ax, [esp + 8]
	mov [gdtr], ax
	lgdt [gdtr]
	ret

global reload_segments
reload_segments:
	; Reload CS segment
	jmp 0x08:reload_CS
reload_CS:
	; Reload data segment registers
	mov ax, 0x10
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	ret