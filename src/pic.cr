struct PIC
	# Ports
	PIC1 = 0x20_u16
	PIC2 = 0xA0_u16
	PIC1_COMMAND = PIC1
	PIC1_DATA = PIC1 + 1
	PIC2_COMMAND = PIC2
	PIC2_DATA = PIC2 + 1

	# Commands
	ICW1_ICW4 = 0x01_u8
	ICW1_SINGLE  = 0x02_u8
	ICW1_INTERVAL4 = 0x04_u8
	ICW1_LEVEL = 0x08_u8
	ICW1_INIT = 0x10_u8

	ICW4_8086 = 0x01_u8
	ICW4_AUTO = 0x02_u8
	ICW4_BUF_SLAVE = 0x08_u8
	ICW4_BUF_MASTER = 0x0C_u8
	ICW4_SFNM = 0x10_u8

	EOI = 0x20_u8

	def self.send_eoi(irq : UInt8)
		IO.out PIC2_COMMAND, PIC_EOI if irq >= 8
		IO.out PIC1_COMMAND, PIC_EOI
	end

	def self.remap(master_offset : UInt8, slave_offset : UInt8)
		a1 = IO.inb PIC1_DATA
		a2 = IO.inb PIC2_DATA

		IO.out PIC1_COMMAND, ICW1_INIT + ICW1_ICW4
		IO.wait
		IO.out PIC2_COMMAND, ICW1_INIT + ICW1_ICW4
		IO.wait

		IO.out PIC1_DATA, master_offset
		IO.wait
		IO.out PIC2_DATA, slave_offset
		IO.wait

		IO.out PIC1_DATA, 4
		IO.wait
		IO.out PIC2_DATA, 2
		IO.wait

		IO.out PIC1_DATA, ICW4_8086
		IO.wait
		IO.out PIC2_DATA, ICW4_8086
		IO.wait

		IO.out PIC1_DATA, a1
		IO.out PIC2_DATA, a2
	end
end