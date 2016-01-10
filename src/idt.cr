require "./pic"

lib CPU
  @[Packed]
  struct IDTDescriptor
    offset_lower : UInt16
    selector : UInt16
    zero : UInt8
    type_attr : UInt8
    offset_upper : UInt16
  end

  fun int_dispatcher : Void
  fun syscall_dispatcher : Void
  fun idt_load(idt : CPU::IDTDescriptor*, size : Int32) : Void

  # ISRs
  fun isr0 : Void
  fun isr1 : Void
  fun isr2 : Void
  fun isr3 : Void
  fun isr4 : Void
  fun isr5 : Void
  fun isr6 : Void
  fun isr7 : Void
  fun isr8 : Void
  fun isr9 : Void
  fun isr10 : Void
  fun isr11 : Void
  fun isr12 : Void
  fun isr13 : Void
  fun isr14 : Void
  fun isr15 : Void
  fun isr16 : Void
  fun isr17 : Void
  fun isr18 : Void
  fun isr19 : Void
  fun isr20 : Void

  # IRQs
  fun isr32 : Void
  fun isr33 : Void
end

struct IDT
  @idt :: CPU::IDTDescriptor[256]
  @pit_handler = ->{}
  @kbd_handler = ->{}

  property pit_handler
  property kbd_handler

  Task32      = 0x85
  Interrupt32 = 0x8E
  Trap32      = 0x8F

  def initialize
    @idt = StaticArray(CPU::IDTDescriptor, 256).new CPU::IDTDescriptor.new
    # Reserved interrupts
    @idt[0] = IDT.encode ->CPU.isr0, Interrupt32
    @idt[1] = IDT.encode ->CPU.isr1, Trap32
    @idt[2] = IDT.encode ->CPU.isr2, Interrupt32
    @idt[3] = IDT.encode ->CPU.isr3, Trap32
    @idt[4] = IDT.encode ->CPU.isr4, Trap32
    @idt[5] = IDT.encode ->CPU.isr5, Interrupt32
    @idt[6] = IDT.encode ->CPU.isr6, Interrupt32
    @idt[7] = IDT.encode ->CPU.isr7, Interrupt32
    @idt[8] = IDT.encode ->CPU.isr8, Interrupt32
    @idt[9] = IDT.encode ->CPU.isr9, Interrupt32
    @idt[10] = IDT.encode ->CPU.isr10, Interrupt32
    @idt[11] = IDT.encode ->CPU.isr11, Interrupt32
    @idt[12] = IDT.encode ->CPU.isr12, Interrupt32
    @idt[13] = IDT.encode ->CPU.isr13, Interrupt32
    @idt[14] = IDT.encode ->CPU.isr14, Interrupt32
    @idt[15] = IDT.encode ->CPU.isr15, Interrupt32
    @idt[16] = IDT.encode ->CPU.isr16, Interrupt32
    @idt[17] = IDT.encode ->CPU.isr17, Interrupt32
    @idt[18] = IDT.encode ->CPU.isr18, Interrupt32
    @idt[19] = IDT.encode ->CPU.isr19, Interrupt32
    @idt[20] = IDT.encode ->CPU.isr20, Interrupt32

    # IRQs
    @idt[32] = IDT.encode ->CPU.isr32, Interrupt32
    @idt[33] = IDT.encode ->CPU.isr33, Interrupt32

    # Syscall
    @idt[80] = IDT.encode ->CPU.syscall_dispatcher, Interrupt32
  end

  def load
    CPU.idt_load @idt.to_unsafe, sizeof(typeof(@idt)) - 1
  end

  def self.encode(handler : -> Void, type_attr : Int)
    descriptor = CPU::IDTDescriptor.new
    descriptor.selector = 0x8_u16 # From GDT: code segment is 0x8
    descriptor.zero = 0_u8
    descriptor.type_attr = type_attr.to_u8

    address = handler.pointer.address.to_u32
    descriptor.offset_lower = (address & 0x0000FFFF).to_u16
    descriptor.offset_upper = ((address & 0xFFFF0000) >> 16).to_u16

    descriptor
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
  case vector
  when 0
    $kernel_panic_handler.call "Divide error"
  when 1
    $kernel_panic_handler.call "Debug exception"
  when 2
    $kernel_panic_handler.call "Non-maskable interrupt"
  when 3
    $kernel_panic_handler.call "Breakpoint"
  when 4
    $kernel_panic_handler.call "Overflow"
  when 5
    $kernel_panic_handler.call "BOUND range exceeded"
  when 6
    $kernel_panic_handler.call "Invalid upcode"
  when 7
    $kernel_panic_handler.call "Device not available"
  when 8
    $kernel_panic_handler.call "Double fault"
  when 9
    $kernel_panic_handler.call "Coprocessor Segment Overrun"
  when 10
    $kernel_panic_handler.call "Invalid TSS"
  when 11
    $kernel_panic_handler.call "Segment Not Present"
  when 12
    $kernel_panic_handler.call "Stack-Segment Fault"
  when 13
    $kernel_panic_handler.call "General Protection Fault"
  when 14
    $kernel_panic_handler.call "Page Fault"
  when 15
    $kernel_panic_handler.call "Reserved"
  when 16
    $kernel_panic_handler.call "x87 FPU error"
  when 17
    $kernel_panic_handler.call "Alignment Check"
  when 18
    $kernel_panic_handler.call "Machine Check"
  when 19
    $kernel_panic_handler.call "SIMD Floating-Point Exception"
  when 20
    $kernel_panic_handler.call "Virtualization Exception"
  when 32
    $idt.pit_handler.call
  when 33
    $idt.kbd_handler.call
  else
    CPU.breakpoint
    $kernel_panic_handler.call "Unhandled interrupt"
  end

  PIC.send_eoi_if_necessary vector
end
