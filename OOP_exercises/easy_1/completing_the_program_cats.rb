=begin
Update this code so that when you run it, you see the following output:

My cat Pudding is 7 years old and has black and white fur.
My cat Butterscotch is 10 years old and has tan and white fur.
=end

class Pet
  def initialize(name, age)
    @name = name
    @age = age
  end
end

class Cat < Pet
  def initialize(name, age, color)
    super(name, age)
    @color = color
  end

  def to_s
    "My cat #{@name} is #{@age} years old and has #{@color} fur."
  end
end

pudding = Cat.new('Pudding', 7, 'black and white')
butterscotch = Cat.new('Butterscotch', 10, 'tan and white')
puts pudding, butterscotch

=begin
Further Exploration

An alternative approach to this problem would be to modify the Pet class to
accept a colors parameter. If we did this, we wouldn't need to supply an
initialize method for Cat.

Why would we be able to omit the initialize method? Would it be a good idea to
modify Pet in this way? Why or why not? How might you deal with some of the
problems, if any, that might arise from modifying Pet?

We would be able to omit the initialize method for Cat because the superclass
constructor would automatically be called. It might be useful to place the
colors parameter in Pet (since any pet could be classified by color). A problem
that might arise (assuming the Pet class is in use already) is that other classes
might inherit from it, and those classes might be maintaining color state information
in another way since it was not implemented in the superclass. With trying it
out, it appears there is no error in duplicating an attr_accessor for the same
instance variable in the superclass and subclass (the methods would be overwritten).

A subclass that has already defined an instance variable for color might be using a
different name for the variable, which could cause confusion (since an object of
the subclass can still call the getter method referencing the superclass color value not
defined for the subclass)--which might be a problem if it is called polymorphically
by a user.  Also, that subclass might have an initialize method that calls
super but does not send the correct number of arguments because the superclass method definition
has been changed, resulting in an error. This could be overcome by making color an optional
parameter to the superclass constructor. (note: these would be referred to as a 'fragile base
class' problem--derived classes could malfunction with changes to the superclass.)
=end


