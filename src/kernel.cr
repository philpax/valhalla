require "./terminal"

module Kernel
	extend self
	@@terminal

	def main
		terminal = @@terminal = Terminal.new
		terminal.clear

		$kernel_panic_handler = ->panic(String)

		terminal.puts 0, 0, Terminal::Color::Black, Terminal::Color::Magenta, "Valhalla"
		terminal.puts 0, 1, Terminal::Color::Black, Terminal::Color::White, "a Crystal-based OS"
	end

	def panic(msg)
		terminal = @@terminal
		return unless terminal.is_a? Terminal

		header_color = Terminal::Color::Red

		terminal.clear
		terminal.fill_rect 0, 0, 80, 1, header_color
		terminal.puts 0, 0, header_color, Terminal::Color::White, "Kernel Panic!"
		terminal.puts 0, 1, Terminal::Color::Black, Terminal::Color::LightGrey, msg

		nil
	end
end