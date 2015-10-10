lib CPU
	fun breakpoint() : Void
	fun halt() : NoReturn
	fun syscall(function : Int32, parameter : Void*) : Void

	# I/O
	fun io_outb(port : UInt16, value : UInt8) : Void
	fun io_outw(port : UInt16, value : UInt8) : Void
	fun io_outl(port : UInt16, value : UInt8) : Void

	fun io_inb(port : UInt16) : UInt8
	fun io_inw(port : UInt16) : UInt16
	fun io_inl(port : UInt16) : UInt32

	fun io_wait() : Void
end