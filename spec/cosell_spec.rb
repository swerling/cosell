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

end

# EOF
