=begin
Consider the following code:

butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

shelter = Shelter.new
shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)
shelter.print_adoptions
puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."
Write the classes and methods that will be necessary to make this code run, and print the following output:

P Hanson has adopted the following pets:
a cat named Butterscotch
a cat named Pudding
a bearded dragon named Darwin

B Holmes has adopted the following pets:
a dog named Molly
a parakeet named Sweetie Pie
a dog named Kennedy
a fish named Chester

P Hanson has 3 adopted pets.
B Holmes has 4 adopted pets.
=end

class Pet
  attr_reader :animal_type, :name

  def initialize(animal_type, name)
    @animal_type = animal_type
    @name = name
  end
end

class Owner
  attr_reader :name
  attr_accessor :number_of_pets

  def initialize(name)
    @name = name
    @number_of_pets = 0
  end
end

class Shelter
  def initialize
    @adoptions = {}
  end

  def adopt(owner, pet)
    adoptions[owner] ||= []
    adoptions[owner] << pet

    owner.number_of_pets += 1
  end

  def print_adoptions
    adoptions.each do |owner, pets|
      if owner.name == 'Animal Shelter'
        puts "The Animal Shelter has the following unadopted pets:"
      else
        puts "#{owner.name} has adopted the following pets:"
      end

      pets.each do |pet|
        puts "a #{pet.animal_type} named #{pet.name}"
      end

      puts
    end
  end

  private

  attr_accessor :adoptions
end

butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')
asta         = Pet.new('dog', 'Asta')
laddie       = Pet.new('dog', 'Laddie')
fluffy       = Pet.new('cat', 'Fluffy')
kat          = Pet.new('cat', 'Kat')
ben          = Pet.new('cat', 'Ben')
chatterbox   = Pet.new('parakeet', 'Chatterbox')
bluebell    =  Pet.new('parakeet', 'Bluebell')

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')
animal_shelter = Owner.new('Animal Shelter')

shelter = Shelter.new
shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)
shelter.adopt(animal_shelter, asta)
shelter.adopt(animal_shelter, laddie)
shelter.adopt(animal_shelter, fluffy)
shelter.adopt(animal_shelter, kat)
shelter.adopt(animal_shelter, ben)
shelter.adopt(animal_shelter, chatterbox)
shelter.adopt(animal_shelter, bluebell)
shelter.print_adoptions
puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."
puts "The Animal shelter has #{animal_shelter.number_of_pets} unadopted pets."

=begin
Further Exploration
I was able to add the additional requirments without changing the interface,
but it required some change to the Shelter#adoptions method for the
different-format output. Here, I created an Owner object for the shelter itself,
keeping the adopted/unadopted data together. This might not be an ideal solution if
the adopt method were expanded to include other aspects of adoption that
would not apply if the shelter were 'adopting' the pet, like invoking an adoption
fee or background check.

My chief design issue is that I kept track of pets in the Shelter object but
not within the Owner object. My solution increments @number_of_pets for each owner,
since the code provided established that as a variable/method of Owner. It would make
more sense to add the pets to the owner object and then have the shelter just
keep track of the owners.

My design was from the perspective of the shelter, so I kept track of owners and
pets in that object. Thinking more about the relationships, Owner 'have' pets, so
that would be the ideal location to keep their information, since the shelter
object can access the pet information via the owner object anyway.
=end
