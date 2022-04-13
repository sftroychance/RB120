=begin
Refactoring given classes to create a common superclass.
=end

class Vehicle
  attr_reader :make, :model

  def initialize(make, model)
    @make = make
    @model = model
  end

  def to_s
    "#{make} #{model}"
  end
end

class Car < Vehicle
  def wheels
    4
  end
end

class Motorcycle < Vehicle
  def wheels
    2
  end
end

class Truck < Vehicle
  attr_reader :payload

  def initialize(make, model, payload)
    super(make, model)
    @payload = payload
  end

  def wheels
    6
  end
end

my_car = Car.new('Chevrolet', 'Cruze')
my_truck = Truck.new('Chevrolet', 'Colorado', 2400)
puts my_car, my_truck
puts my_truck.payload

array = [my_car, my_truck]
array.each do |auto|
  puts auto.make
end


# Would it make sense to define a wheels method in Vehicle even though all of
# the remaining classes would be overriding it? Why or why not? If you think it
# does make sense, what method body would you write?
#
# If all vehicles intended to be superclasses have wheels, then it might make
# sense, even though it will be overridden. Placing it there could indicate
# to the user that it must be implemented (though I don't know yet if there is a
# mechanism to require a subclass to override a method--what would verify
# that?). For this, I would write an empty method in the Vehicles class.
#
# Another option, if we know there are vehicles in our problem set that
# do not have wheels, could be to define a module (Wheelable), but this might
# make sense only if there is other wheel-related functionality defined by
# the module.
