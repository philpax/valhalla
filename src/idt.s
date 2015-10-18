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
	align 4
	isr%1:
		push 0
		pusha
		mov dword [int_error_code], 0
		mov dword [int_index], %1
		jmp int_dispatcher
%endmacro

%macro ISR_ERROR_CODE 1
	global isr%1
	align 4
	isr%1:
		pusha
		mov eax, [esp]
		mov [int_error_code], eax
		mov dword [int_index], %1
		jmp int_dispatcher
%endmacro

extern isr_handler
global int_dispatcher
align 4
int_dispatcher:
	push dword [int_error_code]
	push dword [int_index]
	call isr_handler
	add esp, 8 ; Remove arguments from stack
	popa
	add esp, 4 ; Remove error code from stack
	iret

ISR_NO_ERROR_CODE 0
ISR_NO_ERROR_CODE 1
ISR_NO_ERROR_CODE 2
ISR_NO_ERROR_CODE 3
ISR_NO_ERROR_CODE 4
ISR_NO_ERROR_CODE 5
ISR_NO_ERROR_CODE 6
ISR_NO_ERROR_CODE 7
ISR_ERROR_CODE 8
ISR_NO_ERROR_CODE 9
ISR_ERROR_CODE 10
ISR_ERROR_CODE 11
ISR_ERROR_CODE 12
ISR_ERROR_CODE 13
ISR_ERROR_CODE 14
ISR_NO_ERROR_CODE 15
ISR_NO_ERROR_CODE 16
ISR_ERROR_CODE 17
ISR_NO_ERROR_CODE 18
ISR_NO_ERROR_CODE 19
ISR_NO_ERROR_CODE 20

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