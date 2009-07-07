cosell
    by Steven Swerling
    http://tab-a.slot-z.net

== DESCRIPTION:

Cosell is a minimal implementation of the 'Announcements' observer
framework, originally introduced in VisualWorks Smalltalk 7.4 as a
replacement for 'triggerEvent' style of event notification.  Instead of
triggering events identified by symbols, the events are first class
objects.  For rationale, please see the original blog posting by Vassili
Bykov (refs below).

Lineage

  This implementation is loosely based on Lukas Renggli's tweak of Colin Putney's
  Squeak implementation of Vassili Bykov's Announcements framework for
  VisualWorks Smalltalk.  (Specifically Announcements-lr.13.mcz was used as
  a reference.)
  
  Liberties where taken during the port. In particular, the Announcer class
  in the Smalltalk version is implemented here as a ruby module which can be
  mixed into any object. Also, in this implementation any object (or class)
  can serve as an announcement, so no Announcement class is implemented. 


The Name 'Cosell'

  I chose the name 'Cosell' because 

    a) Howard Cosell is famous for his event notification prowess 
    b) Googling for 'Ruby Announcements', 'Ruby Event Announcements', etc.,
       produced scads of results about ruby meetups, conferences, and the
       like. So I went with something a bit cryptic but hopefully a little
       more searchable. 

See:

  {Original blog posting describing Announcments by Vassili Bykov}[http://www.cincomsmalltalk.com/userblogs/vbykov/blogView?entry=3310034894]

  {More info on the Announcements Framework}[http://wiki.squeak.org/squeak/5734]

== FEATURES/PROBLEMS:

* None known. Not tested on ruby 1.9 yet.

== SYNOPSIS:

    #
    #  The following code will produce the following output:
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
      def show(ann)
        puts ann.to_s
      end
    end

    # Some announcements
    class Announcement
      def to_s
        self.class.to_s
      end
    end

    class WordFromOurSponsor < Announcement
      attr_accessor :word
      def to_s
        "And now a word from our sponsor: '#{word}'"
      end
    end

    class EndOfRound < Announcement
      def to_s
        "End of round #{$round}"
      end
    end

    class KnockOut < Announcement
      def to_s
        self.class.to_s + '!'
      end
    end

    class TKO < KnockOut; end

    $howard = Howard.new
    $tv = Television.new
    $round = 1
    $howard.when_announcing(WordFromOurSponsor, KnockOut) do |ann| 
      $tv.show(ann) 
    end

    announcement = WordFromOurSponsor.new
    announcement.word = 'the'
    $howard.announce(announcement) 
      # => And know a word from our sponsors: 'the' 

    $howard.announce(EndOfRound) 
      # => nothing, you haven't subscribed yet to EndOfRound

    eor_subscription = lambda do |ann|
      $tv.show(ann) 
      $round += 1 
    end

    $howard.when_announcing(EndOfRound, &eor_subscription)

    $howard.queue_announcements!(:sleep_time => 0.05, :announcements_per_cycle => 5)
    14.times {$howard.announce(EndOfRound)} # announcements occur in bg thread

    sleep 0.05 # announcements for the first 5 rounds appear
    sleep 0.05 # announcements for the next 5 rounds
    sleep 0.05 # announcements for end of the next 4 rounds (there is not 15th round
    sleep 0.05 # no announcements, all the announcements have been announced

    $howard.announce(TKO) 
        # => TKO!
    sleep 0.05 # the TKO is announced


== REQUIREMENTS:

* ruby, rubygems

== INSTALL:

* TODO: sudo gem install swerling-cosell
 

== LICENSE:

(The MIT License)

Copyright (c) 2008 

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
