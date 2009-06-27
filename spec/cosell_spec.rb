require File.join(File.dirname(__FILE__), 'spec_helper')

#
# A few mock announcments
#
class; AnnouncementMockA < Cosell::Announcement; end
class; AnnouncementMockB < Cosell::Announcement; end
class; AnnouncementMockC < AnnouncementMockB; end

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

  it "should announce instance of announcement class" do
    # Implemenent
    #   testAnnounceClass
    #   testAnnounceInstance
  end

  it "should execute block specified by subscription" do
    # Implemenent
    #   testAnnounceBlock
  end

  it "should execute method specified by subscription" do
    # Implemenent
    #   testSubscribeSend
  end

  it "should take actions only on announcements of events for which there is a subscribtion" do
    # Implemenent
    #   testSubscribeSet
    #   testSubscribeSubclass
  end

  it "should not take actions after unsubscribing" do
    # Implemenent
    #   testUnsubcribeBlock
    #   testUnsubcribeSent
    #   testUnsubcribeSet
  end

end

# EOF
