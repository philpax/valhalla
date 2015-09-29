require "./terminal"
require "./multiboot"

module Kernel
	extend self
	@@terminal = Terminal.new

	def main(multiboot : Multiboot::Information*)
		terminal = @@terminal = Terminal.new
		terminal.clear

		$kernel_panic_handler = ->panic(String)

		terminal.write "Valhalla", fg: Terminal::Color::Magenta
		terminal.write ": a "
		terminal.write "Crystal", fg: Terminal::Color::White
		terminal.write "-based OS\n"

		info = multiboot.value
		if info.flags.bootloader_name?
			terminal.write "Bootloader:   ", fg: Terminal::Color::DarkGrey
			terminal.write StringView.new(info.bootloader_name)
			terminal.write '\n'
		end

		if info.flags.memory?
			terminal.write "Lower memory: ", fg: Terminal::Color::DarkGrey
			terminal.write info.mem_lower
			terminal.write " bytes\n"

			terminal.write "Upper memory: ", fg: Terminal::Color::DarkGrey
			terminal.write info.mem_upper
			terminal.write " bytes\n"
		end
	end

	def panic(msg)
		terminal = @@terminal
		header_color = Terminal::Color::Red

		terminal.clear
		terminal.fill_rect 0, 0, 80, 1, header_color
		terminal.puts 0, 0, "Kernel Panic!", header_color, Terminal::Color::White
		terminal.puts 0, 1, msg

		CPU.panic()
	end
end