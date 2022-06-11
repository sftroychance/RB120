=begin
This exercise asks you to come up with a class design for a Role-playing Game.

The application has information about every player. They all have a name, health, strength and intelligence.

When each player is created, it gets:

a health value of 100
a random strength value (between 2 and 12, inclusive)
a random intelligence value (between 2 and 12 inclusive)
The random values are determined by a call to a #roll_dice method that cannot be accessed outside of the class.

You can set and change the strength and intelligence in the constructors. However, once an object is constructed, the values may not change.

Health can only be changed by the methods #heal and #hurt. Each method accepts one argument, the amount of change to the health. The #heal increases the health value by the indicated amount, while the #hurt decreases the value.

A player can be a warrior, a paladin, a magician, or a bard.

Warriors receive an additional 2 points of strength when they're created. The resulting strength range is thus between 4 and 14, inclusive.

Magicians receive an additional 2 points of intelligence when they're created. The resulting intelligence range is thus between 4 and 14, inclusive.

Warriors and paladins have the ability to wear armor. They need access to 2 additional methods: #attach_armor and #remove_armor.

Paladins, magicians and bards can cast spells. They need access to a #cast_spell method, that accepts one argument, spell.

Bards are a special type of magician that can also create potions. They have a #create_potion method.

If you pass a player instance to #puts, it should print information about the player in this format:

Name: John
Class: Warrior
Health: 100
Strength: 7
Intelligence:
=end

module Armorable
  def attach_armor
  end

  def remove_armor
  end
end

module Spellable
  def cast_spell(spell)
  end
end

class Player
  def initialize(name)
    @name = name
    @health = 100
    @strength = roll_dice(2, 12)
    @intelligence = roll_dice(2, 12)
  end

  def heal(increase)
    @health += increase
  end

  def hurt(decrease)
    @health -= decrease
  end

  def to_s
    "Name: #{@name}\n" +
    "Class: #{self.class}\n" +
    "Health: #{@health}\n" +
    "Strength: #{@strength}\n" +
    "Intelligence: #{@intelligence}"
  end

  private

  def roll_dice(min, max)
    rand(min..max)
  end
end

class Warrior < Player
  include Armorable

  def initialize(name)
    super
    @strength += 2
  end
end

class Paladin < Player
  include Armorable
  include Spellable
end

class Magician < Player
  include Spellable

  def initialize(name)
    super
    @intelligence += 2
  end
end

class Bard < Magician
  def create_potion
  end
end

magician = Magician.new("Troy")
bard = Bard.new("Bard")
warrior = Warrior.new("Warrior")
paladin = Paladin.new("Paladin")

puts magician
puts bard

