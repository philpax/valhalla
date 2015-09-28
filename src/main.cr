fun kmain()
	Pointer(UInt16).new(0xB8000_u64).map!(80*25) { |value| value = 0xDD00_u16 }
end