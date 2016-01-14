require "./keyboard"

struct Shell
  @buffer = StaticArray(UInt8, 256).new 0_u8
  @buffer_cursor = 0_u32

  def initialize
    $keyboard.on_key_down = ->on_key_down(UInt8, Char)

    present_prompt
  end

  def present_prompt
    $terminal.write "> "
  end

  def process_command
    view = StringView.new @buffer.to_unsafe, @buffer_cursor

    if view == "version"
      $terminal.write "Valhalla", fg: Terminal::Color::Magenta
      $terminal.write ": a "
      $terminal.write "Crystal", fg: Terminal::Color::White
      $terminal.writeln "-based OS"
    else
      $terminal.write "Unrecognised command: "
      $terminal.writeln view  
    end

    @buffer[] = 0_u8
    @buffer_cursor = 0_u32

    present_prompt
  end

  def on_key_down(scanCode : UInt8, char : Char)
    if char == '\n'
      $terminal.writeln
      process_command
      return
    end

    return if char == '\0'
    return if @buffer_cursor >= @buffer.size
    $terminal.write char
    @buffer[@buffer_cursor] = char.ord.to_u8
    @buffer_cursor += 1
  end
end