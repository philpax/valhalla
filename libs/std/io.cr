lib CPU
	# I/O
	fun io_outb(port : UInt16, value : UInt8) : Void
	fun io_outw(port : UInt16, value : UInt16) : Void
	fun io_outl(port : UInt16, value : UInt32) : Void

	fun io_inb(port : UInt16) : UInt8
	fun io_inw(port : UInt16) : UInt16
	fun io_inl(port : UInt16) : UInt32

	fun io_wait() : Void
end

struct IO
	def self.outb(port : UInt16, value : UInt8)
		CPU.io_outb port, value
	end

	def self.outw(port : UInt16, value : UInt16)
		CPU.io_outw port, value
	end

	def self.outl(port: UInt16, value : UInt32)
		CPU.io_outl port, value
	end

	def self.inb(port : UInt16)
		CPU.io_inb(port)
	end

	def self.inw(port : UInt16)
		CPU.io_inw(port)
	end

	def self.inl(port : UInt16)
		CPU.io_inl(port)
	end

	def self.wait()
		CPU.io_wait()
	end
end