=begin
Fix the following code so it works properly:

=> The issue here was that the `mileage = total` statement in
the `increment_mileage` method is actually a local variable
initialization. The variable name must be disambiguated, here by
calling self.mileage, since the attr_accessor has generated the
setter method (as opposed to `@mileage = total`, since we want to
use getter/setter methods everywhere except the constructor).

=end

class Car
  attr_accessor :mileage

  def initialize
    @mileage = 0
  end

  def increment_mileage(miles)
    total = mileage + miles
    self.mileage = total
  end

  def print_mileage
    puts mileage
  end
end

car = Car.new
car.mileage = 5000
car.increment_mileage(678)
car.print_mileage  # should print 5678



