struct StackException
  getter message
  getter cause

  def initialize(message = nil : String?, cause = nil : StackException?)
    @message = message
    @cause = cause
  end
end

module Enumerable(T)
  struct EmptyError < StackException
    def initialize(message = "Empty enumerable")
      super(message)
    end
  end
end

# Raised when the given index is invalid.
#
# ```
# a = [:foo, :bar]
# a[2] #=> IndexError: index out of bounds
# ```
struct IndexError < StackException
  def initialize(message = "Index out of bounds")
    super(message)
  end
end

# Raised when the arguments are wrong and there isn't a more specific `StackException` class.
#
# ```
# [1, 2, 3].take(-4) #=> ArgumentError: attempt to take negative size
# ```
struct ArgumentError < StackException
  def initialize(message = "Argument error")
    super(message)
  end
end

# Raised when the type cast failed.
#
# ```
# [1, "hi"][1] as Int32 #=> TypeCastError: cast to Int32 failed
# ```
struct TypeCastError < StackException
  def initialize(message = "Type Cast error")
    super(message)
  end
end

struct InvalidByteSequenceError < StackException
  def initialize(message = "Invalid byte sequence in UTF-8 string")
    super(message)
  end
end

# Raised when the specified key is not found.
#
# ```
# h = {"foo" => "bar"}
# h["baz"] #=> KeyError: Missing hash key: "baz"
# ```
struct KeyError < StackException
end

struct DivisionByZero < StackException
  def initialize(message = "Division by zero")
    super(message)
  end
end

$kernel_panic_handler

def raise(exception)
  handler = $kernel_panic_handler
  handler.call(exception.message) if handler.is_a?(String -> Nil)
end