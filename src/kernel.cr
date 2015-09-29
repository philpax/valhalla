require "./terminal"

module Kernel
	extend self

	def main
		terminal = Terminal.new
		terminal.clear()
		terminal.map! { |x, y| {Terminal::Color.new(x % 16), Terminal::Color::Black, ' '} }
	end
end