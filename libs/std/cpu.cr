lib CPU
	fun breakpoint() : Void
	fun halt() : NoReturn
	fun syscall(function : Int32, parameter : Void*) : Void
end