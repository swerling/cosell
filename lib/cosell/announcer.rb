require 'logger'

module Cosell

    def initialize *args
      initialize_cosell!
      return super(*args)
    end

    def initialize_cosell!
      @__queue_announcements = false
      @__announcements_queue = nil
      @__kill_announcement_queue = false
      @__announcements_thread = nil
      @__subscriptions = {}
    end

    #
    #
    #           ANNOUNCEMENTS QUEUE
    #
    #

    # Place all announcments in a queue, and make announcements in a background thread.
    #
    # Options:
    #    :sleep_time => how long to sleep (in seconds) after making a batch of announchements 
    #                   default: 0.01
    #    :announcements_per_cycle => how many announcements to make before sleeping for sleep_time
    #                   default: 5
    #    :logger => a logger. Where to log exceptions and warnings
    #
    # Note: at the moment, this method may only be called once, and cannot be undone. There is
    # no way to interrupt the thread.
    
    def queue_announcements!(opts = {})

      # kill off the last queue first
      if @__announcements_thread
        kill_queue!
        sleep 0.01
        queue_announcements! opts
      end

      @__queue_announcements = true
      @__announcements_queue ||= Queue.new

      how_many_per_cycle = opts[:announcements_per_cycle] || 5
      cycle_duration = opts[:sleep_time] || 0.01
      logger = opts[:logger]
      count = 0

      @__announcements_thread ||= Thread.new do 
        begin
          loop do
            if @__kill_announcement_queue
              @__kill_announcement_queue = nil
              @__announcements_thread = nil
              logger.info("Announcement queue killed with #{@__announcements_queue.size} announcements still queued") if logger
              break
            else
              self.announce_now! @__announcements_queue.pop
              count += 1
              if (count%how_many_per_cycle).eql?(0)
                logger.debug "Announcement queue finished batch of #{how_many_per_cycle}, sleeping for #{cycle_duration} sec" if logger
                count = 0
                sleep cycle_duration
              end
            end
          end
        rescue Exception => x
          logger.error("Exception: #{x}, trace: \n\t#{x.backtrace.join("\n\t")}") if logger
        end
      end

    end

    def kill_queue!
      @__kill_announcement_queue = true
    end

    def queue_announcements?
      return @__queue_announcements.eql?(true)
    end

    #
    #
    #           SUBSCRIBE/MAKE ANNOUNCEMENTS 
    #
    #

    # keep this public?
    def subscriptions
      # if user never called 'initialize' on the object this was mixed into, just initialize it now
      self.initialize_cosell! if @__subscriptions.nil?
      @__subscriptions
    end

    def subscriptions= x
      @__subscriptions = x
    end

    # Pass in an anouncement class (or array of announcement classes), along with a block defining the 
    # action to be taken when an announcment of one of the specified classes is announced by this announcer.
    # (see Cossell::Announcer for full explanation)
    def subscribe *announce_classes, &block
      Array(announce_classes).each do |announce_class|
        raise "Can only subscribe to classes, not an class: #{announce_class}" unless announce_class.is_a?(Class)
        self.subscriptions[announce_class] ||= []
        self.subscriptions[announce_class] << lambda(&block)
      end
    end
    alias_method :when_announcing, :subscribe

    # Stop announcing for a given announcement class (or array of classes)
    def unsubscribe *announce_classes
      Array(announce_classes).each do |announce_class|
        self.subscriptions.delete announce_class
      end
    end

    # If queue_announcements? true, puts announcement in a Cosell:ConcurrentAnnouncementQueue.
    # Otherwise, calls announce_now!
    def announce announcement
      if self.queue_announcements?
        @__announcements_queue << announcement
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
        self.subscriptions.each do |subscription_type, subscriptions_for_type |
          if announcement.is_a?(subscription_type)
            subscriptions_for_type.each{|subscription| subscription.call(announcement) }
          end
        end
      end

      return announcement 
    end

    #
    #
    #           DEBUG
    #
    #

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


