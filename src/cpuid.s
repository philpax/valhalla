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

global cpuid_get_feature_information
cpuid_get_feature_information:
	mov eax, 1
	push ebx
	push esi
	cpuid
	mov esi, [esp+12]
	mov [esi+4], ecx
	mov [esi], edx
	pop esi
	pop ebx
	ret