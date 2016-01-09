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

TIMES 5 nop

; Useful functions
global dummy
dummy:
	ret

TIMES 5 nop

global breakpoint
breakpoint:
	xchg bx, bx
	ret

TIMES 5 nop

global enable_interrupts
enable_interrupts:
	sti
	ret

TIMES 5 nop

global disable_interrupts
disable_interrupts:
	cli
	ret

TIMES 5 nop