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