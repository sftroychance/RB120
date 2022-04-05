module Haulable
  def cargo_space?(cubic_feet)
    cubic_feet < 36 ? true : false
  end

  def can_tow?(weight)
    weight < 4000 ? true : false
  end
end

class Vehicle
  @@number_of_vehicles = 0

  attr_accessor :color
  attr_reader :year, :model

  def self.gas_mileage(gallons, miles)
    puts "The gas mileage is #{format("%.2f", miles.fdiv(gallons))} miles per gallon."
  end

  def self.number_of_vehicles
    puts "There are #{@@number_of_vehicles} vehicles currently."
  end

  def initialize(year, color, model)
    @year = year
    self.color = color
    @model = model
    @speed = 0

    @@number_of_vehicles += 1
  end

  def accelerate(increase)
    @speed += increase
    puts "The speed has now increased to #{@speed}"
  end

  def decelerate(decrease)
    @speed -= decrease
    puts "The speed has now decreased to #{@speed}"
  end

  def shutdown
    @speed = 0
    puts "The car is now shut down"
  end

  def spray_paint(new_color)
    self.color = new_color
  end

  def age
    puts "This vehicle is #{age_years} years old"
  end

  private

  def age_years
    Time.now.year - self.year
  end

end

class MyCar < Vehicle
  TRUNK_CAPACITY_CUBIC_FEET = 16.2

  def to_s
    "Car Details: #{self.year} #{self.color} #{self.model}"
  end
end

class MyTruck < Vehicle
  include Haulable

  BED_LENGTH_INCHES = 74

  def to_s
    "Truck Details: #{self.year} #{self.color} #{self.model}"
  end
end

my_first_car = MyCar.new(1978, 'red', 'Ford')
puts my_first_car.year
puts "#{my_first_car}"
p my_first_car

my_first_car.accelerate(20)

my_first_car.decelerate(5)

p my_first_car

my_first_car.shutdown

p my_first_car

my_first_car.spray_paint('black')
p my_first_car

MyCar.gas_mileage(10, 240)

puts my_first_car.to_s
puts "my car: #{my_first_car}"
puts "Trunk capacity: #{MyCar::TRUNK_CAPACITY_CUBIC_FEET} cubic feet"

my_truck = MyTruck.new(2007, 'black', 'Colorado')
puts my_truck
puts "Bed length: #{MyTruck::BED_LENGTH_INCHES} inches"

Vehicle.number_of_vehicles

puts my_truck.can_tow?(4500)
puts my_truck.cargo_space?(20)

puts MyCar.ancestors
puts
puts MyTruck.ancestors

puts my_truck.age
puts my_truck.age_years # -> private method error message
