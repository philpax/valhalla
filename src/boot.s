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

global breakpoint
breakpoint:
	xchg bx, bx
	ret