=begin

The code below raises an exception. Examine the error message and alter the
code so that it runs without error.

=> fix

The statement `super` in SongBird#initialize sends all the arguments sent to
SongBird, but the third argument is for use only by the SongBird class;
`super` needs to be explicitly called with the first two arguments only.

Further exploration: The FlightlessBird#initialize method is not required
because the superclass version takes the same arguments and it performs no
additional actions beyond assigning those arguments to variables. Without
this initialize method, Animal#initialize will be called.

=end

class Animal
  def initialize(diet, superpower)
    @diet = diet
    @superpower = superpower
  end

  def move
    puts "I'm moving!"
  end

  def superpower
    puts "I can #{@superpower}!"
  end
end

class Fish < Animal
  def move
    puts "I'm swimming!"
  end
end

class Bird < Animal
end

class FlightlessBird < Bird
  # def initialize(diet, superpower)
  #   super
  # end

  def move
    puts "I'm running!"
  end
end

class SongBird < Bird
  def initialize(diet, superpower, song)
    # super
    super(diet, superpower)
    @song = song
  end

  def move
    puts "I'm flying!"
  end
end

# Examples

unicornfish = Fish.new(:herbivore, 'breathe underwater')
penguin = FlightlessBird.new(:carnivore, 'drink sea water')
robin = SongBird.new(:omnivore, 'sing', 'chirp chirrr chirp chirp chirrrr')
