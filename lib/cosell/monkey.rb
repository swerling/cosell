class Object

  def as_announcement
    return self
  end

  def self.as_announcement
    new_inst = self.allocate rescue nil
    raise "Cannot create an announcement out of #{self}. Please implement 'as_announcement' as a class method of #{self}." if new_inst.nil?
    new_inst
  end

  def as_announcement_trace
    self.to_s
  end

end



