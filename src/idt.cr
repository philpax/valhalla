lib CPU
	@[Packed]
	struct IDTDescriptor
		offset_lower : UInt16
		selector : UInt16
		zero : UInt8
		type_attr : UInt8
		offset_upper : UInt16
	end

	fun isr_def_handler() : Void
	fun load_idt(idt : UInt64*, size : Int32) : Void
end

struct IDT
	@idt :: UInt64[256]

	def initialize()
		default_value = IDT.encode ->CPU.isr_def_handler, 0x8E
		@idt = StaticArray(UInt64, 256).new default_value

		CPU.load_idt @idt.to_unsafe, sizeof(typeof(@idt))-1
	end

	def self.encode(handler : -> Void, type_attr : Int)
		descriptor = CPU::IDTDescriptor.new
		descriptor.selector = 0x8_u16 # From GDT: code segment is 0x8
		descriptor.zero = 0_u8
		descriptor.type_attr = type_attr.to_u8

		address = handler.pointer.address.to_u32
		descriptor.offset_lower = (address & 0x0000FFFF).to_u16
		descriptor.offset_upper = ((address & 0xFFFF0000) >> 16).to_u16

		# type-pun the struct to a uint64
		(pointerof(descriptor) as UInt64*).value
	end
end