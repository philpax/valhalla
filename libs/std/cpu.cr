lib CPU
  fun breakpoint : Void
  fun halt : NoReturn
  fun syscall(function : Int32, parameter : Void*) : Void

  fun enable_interrupts : Void
  fun disable_interrupts : Void
end
