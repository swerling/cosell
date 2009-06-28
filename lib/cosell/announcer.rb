require 'logger'

module Cosell
  module Announcer

    def subscriptions
      @subscriptions ||= {}
    end

    def queue_announcements!(opts = {})
      @announcements_queued = true
      @announcements_queue ||= Queue.new

      how_many_per_cycle = opts[:announcements_per_cycle] || 5
      cycle_duration = opts[:sleep_time] || 0.01
      count = 0

      @announcements_thread ||= Thread.new do 
        begin
          loop do
            self.announce_now! @announcements_queue.pop
            count += 1
            if (count%how_many_per_cycle).eql?(0)
              count = 0
              sleep cycle_duration
            end
          end
        rescue Exception => x
          msg = "Exception: #{x}, trace: \n\t#{x.backtrace.join("\n\t")}"
          if @logger.nil?
            puts msg
          else
            logger.error msg
          end
        end
      end

    end

    def queue_announcements?
      @announcements_queued.eql?(true)
    end

    # If queue_announcements? true, puts announcement in a Cosell:ConcurrentAnnouncementQueue.
    # Otherwise, calls announce_now!
    def announce announcement
      if self.queue_announcements?
        @announcements_queue << announcement
      else
        self.announce_now! announcement
      end
    end


    #
    # First, an announcement is made by calling 'as_announcement' on an_announcement_or_announcement_factory,
    # and subscribers to the announcement's class are then notified
    #
    # subscribers to this announcer will be filtered to those that match to the announcement's class,
    # and those subscriptions will be 'fired'. Subscribers should use the 'subscribe' method (also
    # called 'when_announcing') to configure actions to take when a given announcement is made.
    #
    # Typically, an announcement is passed in for an_announcement_factory, in
    # which case as_announcement does nothing but return the announcement. But any class can override
    # as_announcement to adapt into an anouncement as they see fit.
    #
    # (see Cossell::Announcer for full explanation)
    #
    def announce_now! an_announcement_or_announcement_factory
      announcement = an_announcement_or_announcement_factory.as_announcement

      unless self.subscriptions.empty?
        self.subscriptions.each do |subscription_type, subscriptions |
          if announcement.is_a?(subscription_type)
            subscriptions.each{|subscription| subscription.call(announcement) }
          end
        end
      end

      return announcement 
    end

    # Pass in an anouncement class (or array of announcement classes), along with a block defining the 
    # action to be taken when an announcment of one of the specified classes is announced by this announcer.
    # (see Cossell::Announcer for full explanation)
    def subscribe *announce_classes, &block
      Array(announce_classes).each do |announce_class|
        raise "Can only subscribe to classes, not an class: #{announce_class}" unless announce_class.is_a?(Class)
        self.subscriptions[announce_class] ||= []
        self.subscriptions[announce_class] << (lambda &block)
      end
    end
    alias_method :when_announcing, :subscribe

    # Stop announcing for a given class
    def unsubscribe *announce_classes
      Array(announce_classes).each do |announce_class|
        self.subscriptions.delete announce_class
      end
    end

    # Log a message every time this announcer makes an announcement
    # Options:
    #    :logger => The log to log to. Default is a logger on STDOUT
    #    :on => Which class of announcements to spy on. Default is Object (ie. all announcements)
    #    :level => The log level to log with. Default is :info
    #    :preface => A message to prepend to all log messages. Default is "Announcement Spy: "
    def spy!(opts = {})
      logger = opts[:logger] || Logger.new(STDOUT)
      on = opts[:on] || Object
      level = opts[:level] || :info
      preface = opts[:preface_with] || "Announcement Spy: "
      self.subscribe(on){|ann| logger.send(level, "#{preface} #{ann.as_announcement_trace}")}
    end

  end
end

