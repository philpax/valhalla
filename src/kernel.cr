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
		terminal.writeln "-based OS"

		info = multiboot.value
		if info.flags.bootloader_name?
			terminal.write "Bootloader:   ", fg: Terminal::Color::DarkGrey
			terminal.writeln StringView.new(info.bootloader_name)
		end

		if info.flags.memory?
			terminal.write "Lower memory: ", fg: Terminal::Color::DarkGrey
			terminal.write info.mem_lower
			terminal.writeln " kilobytes"

			terminal.write "Upper memory: ", fg: Terminal::Color::DarkGrey
			terminal.write info.mem_upper
			terminal.write " kilobytes"
			if info.mem_upper > 1024
				terminal.write " ("
				terminal.write info.mem_upper / 1024
				terminal.write " megabytes)"
			end
			terminal.writeln
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