=begin
What output does this code print? Fix this class so that there are no surprises waiting in store for the unsuspecting developer.

The code prints:
Fluffy
My name is FLUFFY.
FLUFFY
FLUFFY

The #upcase! method mutates the object. To fix, we can remove the mutator.
=end

class Pet
  attr_reader :name

  def initialize(name)
    @name = name.to_s
  end

  def to_s
    "My name is #{name.upcase}."
  end
end

name = 'Fluffy'
fluffy = Pet.new(name)
puts fluffy.name
puts fluffy
puts fluffy.name
puts name

name = 42
fluffy = Pet.new(name)
name += 1
puts fluffy.name
puts fluffy
puts fluffy.name
puts name

# Further exploration: The to_s method in the initializer stores the name value
# as a string (and to_s on an Integer will result in the string equivalent of
# that integer). Incrementing the name value in the main program does not affect
# the instance variable within the class.
