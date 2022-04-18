class Pet
  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end

class Dog < Pet
  def speak
    'bark!'
  end

  def swim
    'swimming!'
  end

  def fetch
    'fetching!'
  end
end

class Cat < Pet
  def speak
    'meow!'
  end
end

class Bulldog < Dog
  def swim
    "can't swim!"
  end
end

delta = Dog.new
p delta.speak
p delta.swim

velma = Cat.new
p velma.speak
p velma.jump

eddie = Pet.new
p eddie.run

bully = Bulldog.new
p bully.swim
p bully.jump

p Bulldog.ancestors
