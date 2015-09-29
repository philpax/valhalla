# A String represents an immutable sequence of UTF-8 characters.
#
# A String is typically created with a string literal, enclosing UTF-8 characters
# in double quotes:
#
# ```
# "hello world"
# ```
#
# A backslash can be used to denote some characters inside the string:
#
# ```
# "\"" # double quote
# "\\" # backslash
# "\e" # escape
# "\f" # form feed
# "\n" # newline
# "\r" # carriage return
# "\t" # tab
# "\v" # vertical tab
# ```
#
# You can use a backslash followed by at most three digits to denote a code point written in octal:
#
# ```text
# "\101" # == "A"
# "\123" # == "S"
# "\12"  # == "\n"
# "\1"   # string with one character with code point 1
# ```
#
# You can use a backslash followed by an *u* and four hexadecimal characters to denote a unicode codepoint written:
#
# ```text
# "\u0041" # == "A"
# ```
#
# Or you can use curly braces and specify up to six hexadecimal numbers (0 to 10FFFF):
#
# ```text
# "\u{41}" # == "A"
# ```
#
# A string can span multiple lines:
#
# ```text
# "hello
#       world" # same as "hello      \nworld"
# ```
#
# Note that in the above example trailing and leading spaces, as well as newlines,
# end up in the resulting string. To avoid this, you can split a string into multiple lines
# by joining multiple literals with a backslash:
#
# ```text
# "hello " \
# "world, " \
# "no newlines" # same as "hello world, no newlines"
# ```
#
# Alterantively, a backlash followed by a newline can be inserted inside the string literal:
#
# ```text
# "hello \
#      world, \
#      no newlines" # same as "hello world, no newlines"
# ```
#
# In this case, leading whitespace is not included in the resulting string.
#
# If you need to write a string that has many double quotes, parenthesis, or similar
# characters, you can use alternative literals:
#
# ```text
# # Supports double quotes and nested parenthesis
# %(hello ("world")) # same as "hello (\"world\")"
#
# # Supports double quotes and nested brackets
# %[hello ["world"]] # same as "hello [\"world\"]"
#
# # Supports double quotes and nested curlies
# %{hello {"world"}} # same as "hello {\"world\"}"
#
# # Supports double quotes and nested angles
# %<hello <"world">> # same as "hello <\"world\">"
# ```
#
# To create a String with embedded expressions, you can use string interpolation:
#
# ```
# a = 1
# b = 2
# "sum = #{a + b}"        # "sum = 3"
# ```
#
# This ends up invoking `Object#to_s(IO)` on each expression enclosed by `#{...}`.
#
# If you need to dynamically build a string, use `String#build` or `StringIO`.
class String
  # :nodoc:
  TYPE_ID = 1

  # :nodoc:
  HEADER_SIZE = sizeof({Int32, Int32, Int32})

  include Comparable(self)

  # Returns the number of bytes in this string.
  #
  # ```
  # "hello".bytesize         #=> 5
  # "你好".bytesize          #=> 6
  # ```
  def bytesize
    @bytesize
  end

  # Returns the `Char` at the give index, or raises `IndexError` if out of bounds.
  #
  # Negative indices can be used to start counting from the end of the string.
  #
  # ```
  # "hello"[0]  # 'h'
  # "hello"[1]  # 'e'
  # "hello"[-1] # 'o'
  # "hello"[-2] # 'l'
  # "hello"[5]  # raises IndexError
  # ```
  def [](index : Int)
    at(index) { raise IndexError.new }
  end

  def []?(index : Int)
    at(index) { nil }
  end

  def []?(str : String)
    includes?(str) ? str : nil
  end

  def [](str : String)
    self[str]?.not_nil!
  end

  def at(index : Int)
    if single_byte_optimizable?
      byte = byte_at?(index)
      return byte ? byte.chr : yield
    end

    index += size if index < 0

    each_char_with_index do |char, i|
      if index == i
        return char
      end
    end

    yield
  end

  def codepoint_at(index)
    char_at(index).ord
  end

  def char_at(index)
    self[index]
  end

  def byte_at?(index)
    byte_at(index) { nil }
  end

  def byte_at(index)
    index += bytesize if index < 0
    if 0 <= index < bytesize
      cstr[index]
    else
      yield
    end
  end

  def unsafe_byte_at(index)
    cstr[index]
  end

  # Yields each char in this string to the block,
  # returns the number of times the block returned a truthy value.
  #
  # ```
  # "aabbcc".count {|c| ['a', 'b'].includes?(c) } #=> 4
  # ```
  def count
    count = 0
    each_char do |char|
      count += 1 if yield char
    end
    count
  end

  # Counts the occurrences of other in this string.
  #
  # ```
  # "aabbcc".count('a') #=> 2
  # ```
  def count(other : Char)
    count {|char| char == other }
  end

  # Sets should be a list of strings following the rules
  # described at Char#in_set?. Returns the number of characters
  # in this string that match the given set.
  def count(*sets)
    count {|char| char.in_set?(*sets) }
  end

  def empty?
    bytesize == 0
  end

  def =~(other)
    nil
  end

  def index(c : Char, offset = 0)
    offset += size if offset < 0
    return nil if offset < 0

    each_char_with_index do |char, i|
      if i >= offset && char == c
        return i
      end
    end

    nil
  end

  def index(c : String, offset = 0)
    offset += size if offset < 0
    return nil if offset < 0

    end_pos = bytesize - c.bytesize

    reader = Char::Reader.new(self)
    reader.each_with_index do |char, i|
      if reader.pos <= end_pos
        if i >= offset && (cstr + reader.pos).memcmp(c.cstr, c.bytesize) == 0
          return i
        end
      else
        break
      end
    end

    nil
  end

  def rindex(c : Char, offset = size - 1)
    offset += size if offset < 0
    return nil if offset < 0

    last_index = nil

    each_char_with_index do |char, i|
      if i <= offset && char == c
        last_index = i
      end
    end

    last_index
  end

  def rindex(c : String, offset = size - c.size)
    offset += size if offset < 0
    return nil if offset < 0

    end_size = size - c.size

    last_index = nil

    reader = Char::Reader.new(self)
    reader.each_with_index do |char, i|
      if i <= end_size && i <= offset && (cstr + reader.pos).memcmp(c.cstr, c.bytesize) == 0
        last_index = i
      end
    end

    last_index
  end

  def byte_index(byte : Int, offset = 0)
    offset.upto(bytesize - 1) do |i|
      if cstr[i] == byte
        return i
      end
    end
    nil
  end

  def byte_index(string : String, offset = 0)
    offset += bytesize if offset < 0
    return nil if offset < 0

    end_pos = bytesize - string.bytesize

    offset.upto(end_pos) do |pos|
      if (cstr + pos).memcmp(string.cstr, string.bytesize) == 0
        return pos
      end
    end

    nil
  end

  # Returns the byte index of a char index, or nil if out of bounds.
  # It is valid to pass `size` to *index*, and in this case the answer
  # will be the bytesize of this string.
  #
  # ```
  # "hello".char_index_to_byte_index(1)     #=> 1
  # "hello".char_index_to_byte_index(5)     #=> 5
  # "こんにちは".char_index_to_byte_index(1) #=> 3
  # "こんにちは".char_index_to_byte_index(5) #=> 15
  # ```
  def char_index_to_byte_index(index)
    reader = Char::Reader.new(self)
    i = 0
    reader.each do |char|
      return reader.pos if i == index
      i += 1
    end
    return reader.pos if i == index
    nil
  end

  # Returns true if `str` contains `search`.
  #
  # ```
  # "Team".includes?('i')             #=> false
  # "Dysfunctional".includes?("fun")  #=> true
  # ```
  def includes?(search : Char | String)
    !!index(search)
  end

  # Yields each character in the string to the block.
  #
  # ```
  # "ab☃".each_char do |char|
  #   char #=> 'a', 'b', '☃'
  # end
  # ```
  def each_char
    if single_byte_optimizable?
      each_byte do |byte|
        yield byte.chr
      end
    else
      Char::Reader.new(self).each do |char|
        yield char
      end
    end
    self
  end

  # Returns an iterator over each character in the string.
  #
  # ```
  # chars = "ab☃".each_char
  # chars.next #=> 'a'
  # chars.next #=> 'b'
  # chars.next #=> '☃'
  # ```
  def each_char
    CharIterator.new(Char::Reader.new(self))
  end

  # Yields each character and its index in the string to the block.
  #
  # ```
  # "ab☃".each_char_with_index do |char, index|
  #   char  #=> 'a', 'b', '☃'
  #   index #=>  0,   1,   2
  # end
  # ```
  def each_char_with_index
    i = 0
    each_char do |char|
      yield char, i
      i += 1
    end
    self
  end

  # Yields each byte in the string to the block.
  #
  # ```
  # "ab☃".each_byte do |byte|
  #   byte #=> 97, 98, 226, 152, 131
  # end
  # ```
  def each_byte
    cstr.to_slice(bytesize).each do |byte|
      yield byte
    end
    self
  end

  # Returns an iterator over each byte in the string.
  #
  # ```
  # bytes = "ab☃".each_byte
  # bytes.next #=> 97
  # bytes.next #=> 98
  # bytes.next #=> 226
  # bytes.next #=> 156
  # bytes.next #=> 131
  # ```
  def each_byte
    to_slice.each
  end

  # Return a hash based on this string’s size and content.
  #
  # See also `Object#hash`.
  def hash
    h = 0
    each_byte do |c|
      h = 31 * h + c
    end
    h
  end

  # Returns the number of unicode codepoints in this string.
  #
  # ```
  # "hello".size         #=> 5
  # "你好".size          #=> 2
  # ```
  def size
    if @length > 0 || @bytesize == 0
      return @length
    end

    i = 0
    count = 0

    while i < bytesize
      c = cstr[i]

      if c < 0x80
        i += 1
      elsif c < 0xe0
        i += 2
      elsif c < 0xf0
        i += 3
      else
        i += 4
      end

      count += 1
    end

    @length = count
  end

  def ascii_only?
    @bytesize == 0 || size == @bytesize
  end

  protected def single_byte_optimizable?
    @bytesize == @length
  end

  protected def size_known?
    @bytesize == 0 || @length > 0
  end

  def to_slice
    Slice.new(cstr, bytesize)
  end

  def to_s
    self
  end

  def cstr
    pointerof(@c)
  end

  def to_unsafe
    cstr
  end

  def unsafe_byte_slice(byte_offset, count)
    Slice.new(cstr + byte_offset, count)
  end

  def unsafe_byte_slice(byte_offset)
    Slice.new(cstr + byte_offset, bytesize - byte_offset)
  end

  # :nodoc:
  class CharIterator
    include Iterator(Char)

    def initialize(@reader, @end = false)
    end

    def next
      return stop if @end

      value = @reader.current_char
      @reader.next_char
      @end = true unless @reader.has_next?

      value
    end

    def rewind
      @reader.pos = 0
      @end = false
      self
    end
  end
end