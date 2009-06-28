module Cosell
  module Announcer

    def subscriptions
      @subscriptions ||= {}
    end

    def queue_announcements!
      @announcements_queued = true
      @announcements_queue ||= Cosell::ConcurrentAnnouncementQueue.new(:announcer => self)
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

    def unsubscribe *announce_classes
      Array(announce_classes).each do |announce_class|
        self.subscriptions.delete announce_class
      end
    end
  end
end

