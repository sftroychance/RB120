=begin
Consider the following class definition:

class Flight
  attr_accessor :database_handle

  def initialize(flight_number)
    @database_handle = Database.init
    @flight_number = flight_number
  end
end
There is nothing technically incorrect about this class, but the definition may lead to problems in the future. How can this class be fixed to be resistant to future problems?

=end

class Flight
  def initialize(flight_number)
    @database_handle = Database.init
    @flight_number = flight_number
  end

  private

  attr_accessor :database_handle
end

# It is perhaps dangerous to allow the user to retrieve a
# database object, since the reference to the object is
# returned, so they could call methods on that object and
# perhaps expose data they are not authorized to access. My
# fix here is to make the attr_accessor private (assuming
# it will be needed by other instance methods).
#
# The solution offers that the attr_accessor should be removed
# entirely. The concern given is not security with exposing
# the database object, but rather code dependency--if this
# class were changed, any code referencing the database handle
# might be broken. (Though this would be true for any exposed
# instance variable, something like a database handle might be
# particularly problematic or could not be redirected to maintain
# functionality.)
