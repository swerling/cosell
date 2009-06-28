#
# Sits by window, talks to cats
#
class CatWhisperer
  include Cosell::Announcer
end

#
# events that occur in the home
#
class SomeoneEnteringHome
  attr_accessor :who_is_entering
end
class OwnerEnteringHome < SomeoneEnteringHome; end
class BurglerEnteringHome < SomeoneEnteringHome; end
class DogEnteringHome < SomeoneEnteringHome; end
class BirdEnteringHome < SomeoneEnteringHome; end

#
# participants
#
class Cat
end
class NormalSizedCat < Cat
  def deal_with_dog(dog)
    if dog.running_at_cat?(self)
      puts "run to bookshelf; climb bookshelf; feign indifference"
    else
      puts "feign indifference; saunter to bookshelf; climb bookshelf; feign indifference"
    end
  end
  def deal_with_burgler(burgler)
    puts "feign indifference"
  end
  def deal_with_owner(owner)
    puts "feign indifference while slowly sauntering towards owner; " \
       + "nuzzle owner; receive affection; try to feign indifference; break down and start purring"
  end

end

class ReallyBigCat < Cat
  def eat(who)
    puts "Really big cat eats #{who}"
  end
  def deal_with_burgler(burgler)
    eat('burgler')
  end
  def deal_with_owner(owner)
    eat('owner')
  end
  def deal_with_dog(owner)
    eat('dog')
  end
end

cat_whisperer = CatWhisperer.new
really_big_cat = ReallyBigCat.new
regular_cat = NormalSizedCat.new

#
# wire up events
#
cat_whisperer.when_announcing(DogEnteringHome) do |event|
  cat.deal_with_dog(event.who_is_entering)
  rally_big_cat.deal_with_dog(event.who_is_entering)
end
cat_whisperer.when_announcing(DogEnteringHome, :send => |event|
  cat.deal_with_dog(event.who_is_entering)
  rally_big_cat.deal_with_dog(event.who_is_entering)
end

cat_whisperer.when_announcing(OwnerEnteringHome) do |event|
  cat.deal_with_person(dog_entering_event.who_is_entering)
  rally_big_cat.deal_with_dog(dog_entering_event.who_is_entering)
end

cat_whisperer.when_announcing(BurglerEnteringHome) do |event|
  cat.deal_with_person(event.who_is_entering)
  rally_big_cat.deal_with_dog(event.who_is_entering)
end

#
# Mayhem ensues
#
cat_whisperer.announce(OwnerEnteringHome.new)
 # => 
