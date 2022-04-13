=begin
Correct the following program so it will work properly. Assume that the Car
class has a complete implementation; just make the smallest possible change to
ensure that cars have access to the drive method.

=> redefine the self.drive method in Drivable; that is a module method and for this
implementation needs to be an instance method
=end

module Drivable
  def drive
  end
end

class Car
  include Drivable
end

bobs_car = Car.new
bobs_car.drive

