struct Terminal
	property memory
	property cursor_x
	property cursor_y

	@cursor_x :: Int32
	@cursor_y :: Int32

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
		@cursor_x = 0
		@cursor_y = 0
	end

	def put(x, y, c, bg = Color::Black, fg = Color::LightGrey)
		@memory[y*@x_size + x] = (bg.value << 12 | fg.value << 8 | c.ord).to_u16()
	end

	def puts(x, y, s, bg = Color::Black, fg = Color::LightGrey)
		s.each_char_with_index { |c, i| self.put(x+i, y, c, bg, fg) }
	end

	def write(c : Char, bg = Color::Black, fg = Color::LightGrey)
		if c == '\n'
			@cursor_y += 1 if c == '\n'
			@cursor_x = 0
		else
			self.put(@cursor_x, @cursor_y, c, bg, fg)
			@cursor_x += 1
		end

		if cursor_x >= @x_size
			@cursor_y += 1
			@cursor_x = @cursor_x.remainder(@x_size)
		end

		@cursor_y = @cursor_y.remainder(@y_size)
	end

	def write(s, bg = Color::Black, fg = Color::LightGrey)
		s.each_char { |c| self.write(c, bg, fg) }
	end

	def write(num : Int, bg = Color::Black, fg = Color::LightGrey)
		# Modified version of Int#unsafe_to_s
	    chars :: UInt8[65]
		ptr_end = chars.to_unsafe + 64
		ptr = ptr_end

		if num != 0
			neg = num < 0

			while num != 0
				ptr -= 1
				ptr.value = (num.remainder(10).abs + '0'.ord).to_u8()
				num /= 10
			end

			if neg
				ptr -= 1
				ptr.value = '-'.ord.to_u8
			end
		else
			ptr -= 1
			ptr.value = '0'.ord.to_u8()
		end

		count = (ptr_end - ptr).to_u32
		self.write StringView.new(ptr, count)
	end

	def writeln(value = "", bg = Color::Black, fg = Color::LightGrey)
		self.write value, bg, fg
		self.write '\n'
	end

	def map!(&block)
		@y_size.times do |y|
			@x_size.times do |x|
				self.put(x, y, *(yield x, y))
			end
		end
	end

	def clear(col = Terminal::Color::Black)
		self.fill_rect(0, 0, @x_size, @y_size, col)
	end

	def fill_rect(x_pos, y_pos, x_size, y_size, col)
		y_size.times do |y|
			x_size.times do |x|
				self.put(x_pos + x, y_pos + y, ' ', col, col)
			end
		end
	end
end

$terminal = Terminal.new