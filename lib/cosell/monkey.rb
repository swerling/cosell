#
# Cosell is intended to be way for objects to 
# communicate throughout the Object graph. It is _supposed_ to be
# pervasive. As such, it has a few top-level methods that all objects inherit.
#
class Object

  # When an object (or class) is announced, :as_announcement is called, the result of which
  # becomes the announcement. By default just returns self, but can be overridden if appropriate.
  # By default, simply return self.
  def as_announcement
    return self
  end

  # When cosell is configured to "spy!", the result of announement.as_announcement_trace is what
  # is sent to the spy log. By default just calls 'to_s'.
  def as_announcement_trace
    self.to_s
  end

  # When a class is used as an announcment, an empty new instance is created using #allocate.
  # Will raise an exception for those rare classes that cannot #allocate a new instance.
  def self.as_announcement
    new_inst = self.allocate rescue nil
    raise "Cannot create an announcement out of #{self}. Please implement 'as_announcement' as a class method of #{self}." if new_inst.nil?
    new_inst
  end

end



