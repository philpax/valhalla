global cpuid_get_vendor_id_string
cpuid_get_vendor_id_string:
	mov eax, 0
	cpuid
	mov eax, [esp+4]
	mov [eax], ebx
	mov [eax+4], edx
	mov [eax+8], ecx
	ret