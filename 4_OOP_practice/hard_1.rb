=begin
1. Ben and Alyssa are working on a vehicle management system. So far, they
have created classes called Auto and Motorcycle to represent automobiles and
motorcycles. After having noticed common information and calculations they
were performing for each type of vehicle, they decided to break out the
commonality into a separate class called WheeledVehicle. This is what their
code looks like so far:

class WheeledVehicle
  attr_accessor :speed, :heading

  def initialize(tire_array, km_traveled_per_liter, liters_of_fuel_capacity)
    @tires = tire_array
    @fuel_efficiency = km_traveled_per_liter
    @fuel_capacity = liters_of_fuel_capacity
  end

  def tire_pressure(tire_index)
    @tires[tire_index]
  end

  def inflate_tire(tire_index, pressure)
    @tires[tire_index] = pressure
  end

  def range
    @fuel_capacity * @fuel_efficiency
  end
end

class Auto < WheeledVehicle
  def initialize
    # 4 tires are various tire pressures
    super([30,30,32,32], 50, 25.0)
  end
end

class Motorcycle < WheeledVehicle
  def initialize
    # 2 tires are various tire pressures
    super([20,20], 80, 8.0)
  end
end

Now Alan has asked them to incorporate a new type of vehicle into their system - a Catamaran defined as follows:

class Catamaran
  attr_reader :propeller_count, :hull_count
  attr_accessor :speed, :heading

  def initialize(num_propellers, num_hulls, km_traveled_per_liter, liters_of_fuel_capacity)
    # ... code omitted ...
  end
end

This new class does not fit well with the object hierarchy defined so far.
Catamarans don't have tires. But we still want common code to track fuel
efficiency and range. Modify the class definitions and move code into a
Module, as necessary, to share code among the Catamaran and the wheeled vehicles.

=> Posted a question in discussion about having an initialize method in the
module Fuelable so the variable initializations for @fuel_efficiency and
@fuel_capacity aren't duplicated. Not sure if this is a good practice, but it
 prevents repetition of code. A solution might be to name that method
something else in Fuelable and call that method from each class initialize
method, but this might sacrifice readability.

2. Building on the prior vehicles question, we now must also track a basic
motorboat. A motorboat has a single propeller and hull, but otherwise behaves
similar to a catamaran. Therefore, creators of Motorboat instances don't need
to specify number of hulls or propellers. How would you modify the vehicles
code to incorporate a new Motorboat class?

=> Added SeaVehicle as a parent class for Motorboat and Catamaran; the
Catamaran class can be empty since the SeaVehicle constructor is fine. The
Motorboat class just overrides the constructor to call super with propeller
and hull counts of 1.

3. The designers of the vehicle management system now want to make an
adjustment for how the range of vehicles is calculated. For the seaborne
vehicles, due to prevailing ocean currents, they want to add an additional
10km of range even if the vehicle is out of fuel.

Alter the code related to vehicles so that the range for autos and
motorcycles is still calculated as before, but for catamarans and motorboats,
 the range method will return an additional 10km.

=> Override the range method in SeaVehicle to call super and then add 10 to
that value.
=end

module Movable
  attr_accessor :speed, :heading

  def initialize(km_traveled_per_liter, liters_of_fuel_capacity)
    @fuel_efficiency = km_traveled_per_liter
    @fuel_capacity = liters_of_fuel_capacity
  end

  def range
    fuel_capacity * fuel_efficiency
  end

  private

  attr_reader :fuel_capacity, :fuel_efficiency
end

class WheeledVehicle
  include Movable

  def initialize(tire_array, km_traveled_per_liter, liters_of_fuel_capacity)
    @tires = tire_array
    super(km_traveled_per_liter, liters_of_fuel_capacity)
  end

  def tire_pressure(tire_index)
    @tires[tire_index]
  end

  def inflate_tire(tire_index, pressure)
    @tires[tire_index] = pressure
  end
end

class Auto < WheeledVehicle
  def initialize
    # 4 tires are various tire pressures
    super([30,30,32,32], 50, 25.0)
  end
end

class Motorcycle < WheeledVehicle
  def initialize
    # 2 tires are various tire pressures
    super([20,20], 80, 8.0)
  end
end

class SeaVehicle
  include Movable

  attr_reader :propeller_count, :hull_count

  def initialize(num_propellers, num_hulls, km_traveled_per_liter, liters_of_fuel_capacity)
    @propeller_count = num_propellers
    @hull_count = num_hulls
    super(km_traveled_per_liter, liters_of_fuel_capacity)
  end

  def range
    super + 10
  end
end

class Catamaran < SeaVehicle
end

class Motorboat < SeaVehicle
  def initialize(km_traveled_per_liter, liters_of_fuel_capacity)
    super(1, 1, km_traveled_per_liter, liters_of_fuel_capacity)
  end
end

my_auto = Auto.new
p my_auto
puts my_auto.range

my_motorcycle = Motorcycle.new
p my_motorcycle
puts my_motorcycle.range

my_catamaran = Catamaran.new(2, 5, 20, 8.0)
p my_catamaran
puts my_catamaran.range

my_motorboat = Motorboat.new(25, 10.0)
p my_motorboat
puts my_motorboat.range

