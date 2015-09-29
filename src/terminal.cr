struct Terminal
	property memory

	enum Color
		Black = 0,
		Blue,
		Green,
		Cyan,
		Red,
		Magenta,
		Brown,
		LightGrey,
		DarkGrey,
		LightBlue,
		LightGreen,
		LightCyan,
		LightRed,
		LightMagenta,
		LightBrown,
		White
	end

	def initialize
		@memory = Pointer(UInt16).new(0xB8000_u64)
		@x_size = 80
		@y_size = 25
	end

	def put(x, y, bg, fg, c)
		@memory[y*@x_size + x] = (bg.value << 12 | fg.value << 8 | c.ord).to_u16()
	end

	def puts(x, y, bg, fg, s)
		s.each_char_with_index { |c, i| self.put(x+i, y, bg, fg, c) }
	end

	def map!(&block)
		@y_size.times do |y|
			@x_size.times do |x|
				self.put(x, y, *(yield x, y))
			end
		end
	end

	def clear(col = Terminal::Color::Black)
		self.map! { {col, col, ' '} }
	end

	def fill_rect(x_pos, y_pos, x_size, y_size, col)
		y_size.times do |y|
			x_size.times do |x|
				self.put(x_pos + x, y_pos + y, col, col, ' ')
			end
		end
	end
end