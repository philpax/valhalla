fun kmain()
	i = 0
	while i < 80*25
		vid_mem = Pointer(UInt16).new(0xB8000_u64 + i*2)
		vid_mem.value = 0xDD00_u16
		i = i + 1
	end
end