struct StringView
  @ptr :: UInt8*
  @size :: UInt32

  getter :ptr
  getter :size

  def initialize(ptr : UInt8*, size = 0_u32)
    @ptr = ptr
    @size = size > 0 ? size : strlen(ptr)
  end

  def initialize(slice : Slice(UInt8))
    initialize(slice.to_unsafe, slice.size.to_u32)
  end

  def initialize(s : String)
    @ptr = s.to_unsafe
    @size = s.bytesize.to_u32
  end

  def each_byte
    @size.times { |i| yield @ptr[i] }
    self
  end

  def each_byte_with_index
    i = 0
    each_byte do |byte|
      yield byte, i
      i += 1
    end
    self
  end

  def each_char
    each_byte { |b| yield b.chr }
  end

  def each_char_with_index(&block)
    each_byte_with_index { |b, i| yield b.chr, i }
  end

  def map_byte!
    @size.times { |i| @ptr[i] = yield i }
  end

  def ==(b : String)
    return false if @size != b.bytesize
    self.each_byte_with_index do |byte, index|
      return false if b.byte_at?(index) != byte
    end
    return true
  end
end
