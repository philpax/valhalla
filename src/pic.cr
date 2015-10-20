struct PIC
	# Ports
	PIC1 = 0x20_u16
	PIC2 = 0xA0_u16
	PIC1_COMMAND = PIC1
	PIC1_DATA = PIC1 + 1_u8
	PIC2_COMMAND = PIC2
	PIC2_DATA = PIC2 + 1_u8

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

	@@master_offset = 0_u8
	@@slave_offset = 0_u8

	def self.send_eoi(irq : UInt8)
		IO.outb PIC2_COMMAND, EOI if irq >= 8
		IO.outb PIC1_COMMAND, EOI
	end

	def self.send_eoi_if_necessary(vector : UInt8)
		if vector >= @@master_offset && vector <= @@master_offset + 7
			self.send_eoi vector - @@master_offset
		elsif vector >= @@slave_offset && vector <= @@slave_offset + 8
			self.send_eoi vector - @@slave_offset
		end
	end

	def self.remap(master_offset : UInt8, slave_offset : UInt8)
		@@master_offset = master_offset
		@@slave_offset = slave_offset

		# Save original masks
		a1 = IO.inb PIC1_DATA
		a2 = IO.inb PIC2_DATA

		# Start the initialisation sequence for master and slave
		IO.outb PIC1_COMMAND, ICW1_INIT + ICW1_ICW4
		IO.wait
		IO.outb PIC2_COMMAND, ICW1_INIT + ICW1_ICW4
		IO.wait

		# Communicate the new offsets
		IO.outb PIC1_DATA, master_offset
		IO.wait
		IO.outb PIC2_DATA, slave_offset
		IO.wait

		# Notify Master PIC of Slave PIC's location
		IO.outb PIC1_DATA, 4_u8
		IO.wait

		# Notify Slave PIC of its cascade identity
		IO.outb PIC2_DATA, 2_u8
		IO.wait

		# Tell both PICs to operate in 8086 mode
		IO.outb PIC1_DATA, ICW4_8086
		IO.wait
		IO.outb PIC2_DATA, ICW4_8086
		IO.wait

		# Restore the masks
		IO.outb PIC1_DATA, a1
		IO.outb PIC2_DATA, a2
	end

	def self.set_mask(irq : UInt8, masked : Bool)
		if irq < 8
			port = PIC1_DATA
		else
			port = PIC2_DATA
			irq -= 8
		end

		mask = 0_u8
		if masked
			mask = IO.inb(port) | (1 << irq)
		else
			mask = IO.inb(port) & ~(1 << irq)
		end
		IO.outb port, mask.to_u8
	end

	def self.mask_all
		IO.outb PIC1_DATA, 0xFF_u8
		IO.outb PIC2_DATA, 0xFF_u8
	end
end