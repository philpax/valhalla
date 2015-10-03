; IDT manipulation
idtr dw 0 ; IDT entry count
	 dd 0 ; IDT entries location

global load_idt
load_idt:
	mov eax, [esp + 4]
	mov [idtr + 2], eax
	mov ax, [esp + 8]
	mov [idtr], ax
	lidt [idtr]
	ret

global isr_def_handler
isr_def_handler:
	iret

global make_syscall
make_syscall:
	mov eax, [esp+4]
	int 80
	ret