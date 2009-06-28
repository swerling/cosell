require File.join(File.dirname(__FILE__), 'spec_helper')

#
# A few mock announcments
#
class AnnouncementA; end
class AnnouncementB; end
class AnnouncementC < AnnouncementB; end

#
# A class whose objects can act as announcers
#
class AnyOldClass; include Cosell::Announcer; end

#
# The tests
#
describe Cosell do

  before(:each) do
    @announcer = AnyOldClass.new
  end

  it "should create announcement from class if needed" do
    @announcer.announce(AnnouncementA).class.should == AnnouncementA
    @announcer.announce(AnnouncementA.new).class.should == AnnouncementA
  end

  it "should execute block specified by subscription" do
    
    #@announcer.spy!

    # Make sure the subscription block fires when an AnnouncementA is 
    # announced, setting what_was_announced to the announcement)
    what_was_announced = nil
    @announcer.when_announcing(AnnouncementB) { |ann| what_was_announced = ann }
    @announcer.announce AnnouncementB
    what_was_announced.should_not be_nil
    what_was_announced.class.should be_eql AnnouncementB
   
    what_was_announced = nil
    @announcer.announce AnnouncementC
    what_was_announced.should_not be_nil
    what_was_announced.class.should be_eql AnnouncementC
  end

  it "should take actions only on announcements of events for which there is a subscribtion" do
    # Make sure the subscription block fires when an AnnouncementA is 
    # announced, setting what_was_announced to the announcement)
    what_was_announced = nil
    @announcer.when_announcing(AnnouncementB) { |ann| what_was_announced = ann }

    @announcer.announce AnnouncementA
    what_was_announced.should be_nil
    @announcer.announce AnnouncementC
    what_was_announced.should_not be_nil
  end

  it "should be able to subscribe to set of announcements types" do
    what_was_announced = nil
    @announcer.when_announcing(AnnouncementA, AnnouncementB) { |ann| what_was_announced = ann }

    what_was_announced = nil
    @announcer.announce AnnouncementA
    what_was_announced.should_not be_nil

    what_was_announced = nil
    @announcer.announce AnnouncementB
    what_was_announced.should_not be_nil
  end

  it "should not take actions after unsubscribing" do
    what_was_announced = nil
    @announcer.when_announcing(AnnouncementA, AnnouncementB) { |ann| what_was_announced = ann }
    @announcer.announce AnnouncementA
    what_was_announced.should_not be_nil

    @announcer.unsubscribe(AnnouncementA)
    what_was_announced = nil
    @announcer.announce AnnouncementA
    what_was_announced.should be_nil
    @announcer.announce AnnouncementB
    what_was_announced.should_not be_nil
  end

  it "should be able to queue announcements" do
    what_was_announced = nil
    count = 0
    sleep_time = 0.1
    how_many_each_cycle = 7
    @announcer.queue_announcements!(:sleep_time => sleep_time, :announcements_per_cycle => how_many_each_cycle)
    @announcer.when_announcing(AnnouncementA) { |ann| count += 1 }

    # @announcer.spy! #dbg

    little_bench("time to queue 100_000 announcements"){100_000.times {@announcer.announce AnnouncementA}}


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

  end

  protected

    def little_bench(msg, &block)
      start = Time.now
      result = block.call
      puts "#{msg}: #{Time.now - start} sec"
      return result
    end
end

# EOF
