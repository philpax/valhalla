require "./terminal"

module Kernel
	extend self

	def main
		terminal = Terminal.new
		terminal.clear()

		terminal.puts 0, 0, Terminal::Color::Black, Terminal::Color::Magenta, "Valhalla"
		terminal.puts 0, 1, Terminal::Color::Black, Terminal::Color::White, "a Crystal-based OS"
	end
end