struct Int
  def /(x : Int)
    unsafe_div x
  end

  def %(other : Int)
    if (self ^ other) >= 0
      self.unsafe_mod(other)
    else
      me = self.unsafe_mod(other)
      me == 0 ? me : me + other
    end
  end

  def remainder(other : Int)
    unsafe_mod other
  end

  def >>(count : Int)
    self.unsafe_shr(count)
  end
  
  def <<(count : Int)
    self.unsafe_shl(count)
  end
end