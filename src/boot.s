MBALIGN     equ  1<<0
MEMINFO     equ  1<<1
FLAGS       equ  MBALIGN | MEMINFO
MAGIC       equ  0x1BADB002
CHECKSUM    equ -(MAGIC + FLAGS)

global panic

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
global _start

_start:
	mov esp, stack_top

	extern kmain
	push ebx
	call kmain
panic:
	cli
	hlt
_halt:
	jmp _halt