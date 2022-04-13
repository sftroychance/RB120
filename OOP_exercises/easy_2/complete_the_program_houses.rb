=begin
Modify the House class so that the above program will work. You are permitted to
define only one new method in House.

Expected output:
Home 1 is cheaper
Home 2 is more expensive

=> define method <=> to allow comparison operators to work
=> must include Comparable for this functionality
=end

class House
  include Comparable

  attr_reader :price

  def initialize(price)
    @price = price
  end

  def <=>(other)
    price <=> other.price # refactor; <=> is defined for numerics so we can use it here
    # if price < other.price
    #   -1
    # elsif price > other.price
    #   1
    # else
    #   0
    # end
  end
end

home1 = House.new(100_000)
home2 = House.new(150_000)
puts "Home 1 is cheaper" if home1 < home2
puts "Home 2 is more expensive" if home2 > home1

=begin
Further exploration:
This seems like a good use for comparable, as price would be the logical
type of comparison between houses. There are other criteria that could be
compared (size of house, number of bedrooms, etc), but price I think would
be the intuitive result of comparison. Much depends on the context of its use;
subclasses can override the method to compare along different criteria. If
the program establishes a context where the primary form of comparison is
by price, I would think this appropriate, but if there are multiple points of
comparison used in the code, I would leave it out. Also, if House objects
are intended to be used across many contexts in the same program, the class
should not use Comparable this way.

Classes where it makes sense to use Comparable are those where its
use would be intuitive to the user and makes sense in the context of
its use. A Person class would not make sense, but a class of objects
that have inherent quantity or value representations would be appropriate.
Classroom might be a class where comparison of size would make sense.
=end
