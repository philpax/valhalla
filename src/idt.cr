lib CPU
	@[Packed]
	struct IDTDescriptor
		offset_lower : UInt16
		selector : UInt16
		zero : UInt8
		type_attr : UInt8
		offset_upper : UInt16
	end

	fun int_dispatcher() : Void
	fun syscall_dispatcher() : Void
	fun load_idt(idt : UInt64*, size : Int32) : Void
end

struct IDT
	@idt :: UInt64[256]

	def initialize()
		default_value = IDT.encode ->CPU.int_dispatcher, 0x8E
		@idt = StaticArray(UInt64, 256).new default_value
		@idt[80] = IDT.encode ->CPU.syscall_dispatcher, 0x8E
	end

	def load()
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

$idt = IDT.new

fun syscall_handler(function : UInt32, parameter : Void*)
	$terminal.write "syscall("
	$terminal.write function
	$terminal.write ", "
	$terminal.write parameter.address.to_u32
	$terminal.writeln ")"
end

fun isr_handler(vector : UInt8, error_code : UInt32)
	$terminal.write "Interrupt "
	$terminal.writeln vector
end