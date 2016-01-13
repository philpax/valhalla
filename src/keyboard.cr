require "./pic"
require "./terminal"

struct Keyboard
  getter active
  property on_key_up
  property on_key_down

  INPUT_PORT = 0x60_u16
  CMD_PORT = 0x64_u16
  
  KEY_RELEASE = 0x80
  KEY_CAPS_LOCK = 58

  @[Flags]
  enum Stats
    OutBuf = 1,
    InBuf = 2
  end

  def initialize
    @keymap = Slice(UInt8).new Pointer(UInt8).null, 0
    @states = StaticArray(Bool, 256).new false
    @caps = false

    @on_key_up = ->(scanCode: UInt8, char: Char) {}
    @on_key_down = ->(scanCode: UInt8, char: Char) { $terminal.write char if char != 0 }
  end

  def init(keymap : Slice(UInt8))
    $idt.set_handler 33, ->handler(UInt8)
    self.active = true

    @keymap = keymap
  end

  def handler(vector)
    scanCode = IO.inb(INPUT_PORT)

    if (scanCode & KEY_RELEASE) != 0
      scanCode -= KEY_RELEASE
      @states[scanCode] = false
    else
      @caps = !@caps if scanCode == KEY_CAPS_LOCK
      @states[scanCode] = true
    end

    offset = uppercase? ? 1 : 0
    char = @keymap[2*scanCode + offset].chr

    if @states[scanCode]
      @on_key_down.call scanCode, char
    else
      @on_key_up.call scanCode, char
    end

    nil
  end

  def shift?
    @states[42] || @states[54]
  end

  def control?
    @states[29]
  end

  def alt?
    @states[56]
  end

  def caps?
    @caps
  end

  def uppercase?
    shift? ^ @caps
  end

  def active=(active : Bool)
    PIC.set_mask 1_u8, !active
    @active = active
  end
end

$keyboard = Keyboard.new
