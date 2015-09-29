lib LibC
  ifdef x86_64
    alias SizeT = UInt64
    alias SSizeT = Int64
  else
    alias SizeT = UInt32
    alias SSizeT = Int32
  end

  alias Char = UInt8
  alias SChar = Int8
  alias Short = Int16
  alias UShort = UInt16
  alias Int = Int32
  alias UInt = UInt32
  alias Long = SSizeT
  alias ULong = SizeT
  alias LongLong = Int64
  alias ULongLong = UInt64
  alias Float = Float32
  alias Double = Float64

  alias PtrDiffT = SSizeT
  alias TimeT = SSizeT
  alias PidT = Int
  alias OffT = SSizeT
end

def Int8.new(value)
  value.to_i8
end

def Int16.new(value)
  value.to_i16
end

def Int32.new(value)
  value.to_i32
end

def Int64.new(value)
  value.to_i64
end

def UInt8.new(value)
  value.to_u8
end

def UInt16.new(value)
  value.to_u16
end

def UInt32.new(value)
  value.to_u32
end

def UInt64.new(value)
  value.to_u64
end

def Float32.new(value)
  value.to_f32
end

def Float64.new(value)
  value.to_f64
end