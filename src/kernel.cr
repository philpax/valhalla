require "./terminal"

module Kernel
	extend self
	@@terminal = Terminal.new

	def main
		terminal = @@terminal = Terminal.new
		terminal.clear

		$kernel_panic_handler = ->panic(String)

		terminal.write "Valhalla", fg: Terminal::Color::Magenta
		terminal.write ": a "
		terminal.write "Crystal", fg: Terminal::Color::White
		terminal.write "-based OS"
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