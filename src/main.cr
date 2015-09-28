fun kmain()
	(80*25).times do |i|
		vid_mem = Pointer(UInt16).new(0xB8000_u64 + i*2)
		vid_mem.value = 0xDD00_u16
	end
end