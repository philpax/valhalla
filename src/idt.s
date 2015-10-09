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

int_error_code dd 0
int_index db 0

%macro ISR_NO_ERROR_CODE 1
	global isr%1
	isr%1:
		push 0
		mov int_error_code, 0
		mov int_index, %1
		jmp int_dispatcher
%endmacro

%macro ISR_ERROR_CODE 1
	global isr%1
	isr%1:
		mov int_error_code, [esp]
		mov int_index, %1
		jmp int_dispatcher
%endmacro

extern isr_handler
global int_dispatcher
int_dispatcher:
	pusha
	push int_error_code
	push int_index
	call isr_handler
	popa
	add esp, 4 ; Remove error code from stack
	iret

extern syscall_handler
global syscall_dispatcher
syscall_dispatcher:
	pusha
	push edx
	push eax
	call syscall_handler
	pop eax
	pop edx
	popa
	iret

global syscall
syscall:
	mov edx, [esp+8]
	mov eax, [esp+4]
	int 80
	ret