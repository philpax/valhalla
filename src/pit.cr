require "./pic"

struct PIT
  @divider = 1_u16
  getter divider

  @active = false
  getter active

  CHANNEL0 = 0x40_u16
  CHANNEL1 = 0x41_u16
  CHANNEL2 = 0x42_u16
  COMMAND  = 0x43_u16

  enum AccessMode
    LatchCountValue = 0_u8,
    LobyteOnly      = 1_u8,
    HibyteOnly      = 2_u8,
    LobyteHiByte    = 3_u8
  end

  enum OperatingMode
    InterruptOnTerminalCount     = 0_u8,
    HardwareRetriggerableOneshot = 1_u8,
    RateGenerator                = 2_u8,
    SquareWaveGenerator          = 3_u8,
    SoftwareTriggeredStrobe      = 4_u8,
    HardwareTriggeredStrobe      = 5_u8
  end

  def initialize
    $idt.set_handler 32, ->handler(UInt8)
  end

  def handler(vector)
  end

  def active=(active : Bool)
    PIC.set_mask 0_u8, !active
    @active = active
  end

  def divider=(divider : UInt16)
    @divider = divider

    # PIT: Channel 0, low-byte/high-byte, rate generator
    IO.outb COMMAND, (0_u8 << 6) | (AccessMode::LobyteHiByte.value << 4) | (OperatingMode::RateGenerator.value << 1)
    # Low 8 bits of divider
    IO.outb CHANNEL0, @divider.to_u8
    # High 8 bits of divider
    IO.outb CHANNEL0, (@divider >> 8).to_u8
  end
end
