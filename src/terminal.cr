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

	def write(x, y, bg, fg, c)
		@memory[y*@x_size + x] = (bg.value << 12 | fg.value << 8 | c.ord).to_u16()
	end

	def map!(&block)
		@y_size.times do |y|
			@x_size.times do |x|
				self.write(x, y, *(yield x, y))
			end
		end
	end

	def clear
		self.map! { {Color::Black, Color::Black, ' '} }
	end
end