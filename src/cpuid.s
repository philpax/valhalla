global cpuid_get_vendor_id_string
cpuid_get_vendor_id_string:
	mov eax, 0
	push ebx
	cpuid
	mov eax, [esp+8]
	mov [eax], ebx
	mov [eax+4], edx
	mov [eax+8], ecx
	pop ebx
	ret