require File.join(File.dirname(__FILE__), 'spec_helper')

#
# A few announcments
#
class AWordFromOurSponsor
  attr_accessor :word
end
class KnockOut; end
class TKO < KnockOut; end

#
# A class whose objects can act as announcers
#
class AnyOldClass; include Cosell; end

#
# The tests
#
describe Cosell do

  before(:each) do
    @announcer = AnyOldClass.new
    @announcer.initialize_cosell!
  end

  it "should instantiate announcement instance from class if needed" do
    @announcer.announce(AWordFromOurSponsor).class.should be_eql(AWordFromOurSponsor)
    @announcer.announce(AWordFromOurSponsor.new).class.should be_eql(AWordFromOurSponsor)
  end

  it "should execute block specified by subscription" do
    
    #@announcer.spy!

    # After subscribing to KnockOut, make sure it fires whenever
    # KnockOut or it's subclass TKO are announced.
    # Also make sure it fires when instances of those classes are announced
    what_was_announced = nil
    @announcer.when_announcing(AWordFromOurSponsor, KnockOut) { |ann| what_was_announced = ann }

    what_was_announced = nil
    @announcer.announce KnockOut
    what_was_announced.should_not be_nil
    what_was_announced.class.should be_eql KnockOut
   
    what_was_announced = nil
    @announcer.announce TKO
    what_was_announced.should_not be_nil
    what_was_announced.class.should be_eql TKO

    #
    # Do the same thing as above, but announce instances (test above used the class as the announcement)
    # make sure if an announcement instance is announced, that the exact instance is what is announced
    #
    what_was_announced = nil
    announcement = AWordFromOurSponsor.new
    announcement.word = 'the'
    @announcer.announce announcement
    what_was_announced.should_not be_nil
    what_was_announced.class.should be_eql AWordFromOurSponsor
    what_was_announced.word.should be_eql('the')
   
    what_was_announced = nil
    @announcer.announce TKO.new
    what_was_announced.should_not be_nil
    what_was_announced.class.should be_eql TKO
  end

  it "should take actions only on announcements of events for which there is a subscription" do
    # Make sure the subscription block fires when an AWordFromOurSponsor is 
    # announced, setting what_was_announced to the announcement)
    what_was_announced = nil
    @announcer.when_announcing(KnockOut) { |ann| what_was_announced = ann }

    @announcer.announce AWordFromOurSponsor
    what_was_announced.should be_nil

    @announcer.announce AWordFromOurSponsor.new # also test announcement instances
    what_was_announced.should be_nil

    @announcer.announce TKO # subclass of Knockout, should be announced
    what_was_announced.should_not be_nil
  end

  it "should be able to subscribe to set of announcements types" do
    what_was_announced = nil
    @announcer.when_announcing(AWordFromOurSponsor, KnockOut) { |ann| what_was_announced = ann }

    what_was_announced = nil
    @announcer.announce AWordFromOurSponsor
    what_was_announced.should_not be_nil

    what_was_announced = nil
    @announcer.announce KnockOut
    what_was_announced.should_not be_nil
  end

  it "should not take actions after unsubscribing" do
    what_was_announced = nil
    @announcer.when_announcing(AWordFromOurSponsor, KnockOut) { |ann| what_was_announced = ann }
    @announcer.announce AWordFromOurSponsor
    what_was_announced.should_not be_nil

    @announcer.unsubscribe(AWordFromOurSponsor)
    what_was_announced = nil
    @announcer.announce AWordFromOurSponsor
    what_was_announced.should be_nil
    @announcer.announce KnockOut
    what_was_announced.should_not be_nil
  end

  it "should be able to queue announcements" do
    what_was_announced = nil
    count = 0
    sleep_time = 0.1
    how_many_each_cycle = 77
    @announcer.queue_announcements!(:sleep_time => sleep_time, 
                                    :logger => Logger.new(STDOUT),
                                    :announcements_per_cycle => how_many_each_cycle)
    @announcer.when_announcing(AWordFromOurSponsor) { |ann| count += 1 }

    little_bench("time to queue 10_000 announcements"){10_000.times {@announcer.announce AWordFromOurSponsor}}

    # @announcer.spy! #dbg

    # Allow announcer thread to do a few batches of announcements, checking the 
    # count after each batch. Since we may get to this part of the thread after
    # the announcer has already made a few announcements, use the count at
    # this moment as the starting_count
    start_count = count
    #puts "-------start count: #{count}" # dbg

    sleep sleep_time + 0.01
    #puts "-------count: #{count}" # dbg
    count.should be_eql(start_count + 1*how_many_each_cycle)

    sleep sleep_time
    #puts "-------count: #{count}" # dbg
    count.should be_eql(start_count + 2*how_many_each_cycle)

    sleep sleep_time
    #puts "-------count: #{count}" # dbg
    count.should be_eql(start_count + 3*how_many_each_cycle)

    # See if killing the queue stops announcments that where queued
    @announcer.kill_queue!
    count_after_queue_stopped = count
    #puts "-------count after stopping: #{count}" # dbg
    sleep sleep_time * 2
    count.should be_eql(count_after_queue_stopped)

  end

#  it "should suppress announcements during suppress_announcements block" do
#    # TODO: support for this idiom:
#    notifier.suppress_announcements_during {
#    }
#       and
#    notifier.suppress_announcements(EventType,
#                                    :during => lambda { "some operation" },
#                                    :send_unique_events_when_done => true)
#       and
#    notifier.suppress_announcements(EventType,
#                                    :during => lambda { "some operation" },
#                                    :send_all_events_when_done => true)
#  end

  protected

    def little_bench(msg, &block)
      start = Time.now
      result = block.call
      puts "#{msg}: #{Time.now - start} sec"
      return result
    end
end

# EOF
