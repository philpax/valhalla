struct Pointer(T)
  def advance_bytes(bytes : Int)
    Pointer(T).new self.address + bytes
  end
end
