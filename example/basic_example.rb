#
#  Will produce the following output:
#
#       And now a word from our sponsor: 'the'
#       End of round 1
#       End of round 2
#       End of round 3
#       End of round 4
#       End of round 5
#       End of round 6
#       End of round 7
#       End of round 8
#       End of round 9
#       End of round 10
#       End of round 11
#       End of round 12
#       End of round 13
#       End of round 14
#       TKO!
        
require 'rubygems'
require 'cosell'

# An announcer
class Howard
  include Cosell
end

# a receiver of the announcements
class Television
  def show(ann, opts={})
    puts ann.to_s(opts)
  end
end

# Some announcements
class Announcement
  def to_s(opts={})
    self.class.to_s + '!'
  end
end
class WordFromOurSponsor < Announcement
  attr_accessor :word
  def to_s(opts={})
    "And now a word from our sponsor: '#{word}'"
  end
end
class EndOfRound < Announcement
  def to_s(opts={})
    "End of round #{opts[:round]}"
  end
end
class KnockOut < Announcement; end
class TKO < KnockOut; end


# ------- Start announcing -------

# Create an announcer, and a subscriber
round = 1
howard = Howard.new
tv = Television.new
howard.when_announcing(WordFromOurSponsor, KnockOut) { |ann| tv.show(ann) }

# Make an announcement
announcement = WordFromOurSponsor.new
announcement.word = 'the'
howard.announce(announcement) 
   # => And know a word from our sponsors: 'the' 

# Make another announcement 
howard.announce(EndOfRound) 
  # => nothing, you haven't subscribed yet to EndOfRound. Tree fell, nobody heard. Didn't happen.

# Create a second subscription
eor_subscription = lambda do |ann|
  tv.show(ann, :round => round) 
  round += 1 
end
howard.when_announcing(EndOfRound, &eor_subscription)

# Tell the announcer to use a background announcments queue
# Only allow the announcer to broadcast 5 announcments at a time
# before going to sleep for 0.05 seconds
howard.queue_announcements!(:sleep_time => 0.05, :announcements_per_cycle => 5)

# Start making announcments (they will be queueud in the background)
14.times {howard.announce(EndOfRound)} 

sleep 0.05 # announcements for the first 5 rounds appear
sleep 0.05 # announcements for the next 5 rounds
sleep 0.05 # announcements for end of the next 4 rounds (there is not 15th round
sleep 0.05 # no announcements, all the announcements have been announced

# queue the final announcment
howard.announce(TKO) 
    # => TKO!

sleep 0.05 # the TKO is broadcast
