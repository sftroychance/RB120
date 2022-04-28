=begin
1.Which of the following are objects in Ruby? If they are objects, how can you
find out what class they belong to?

true
"hello"
[1, 2, 3, "happy days"]
142

=> These are all objects.  You can determine the class by calling the #class
method on each object:
=end
puts true.class
puts "hello".class
puts [1, 2, 3, "happy days"].class
puts 142.class

=begin
2. If we have a Car class and a Truck class and we want to be able to go_fast,
how can we add the ability for them to go_fast using the module Speed? How can
you check if your Car or Truck can now go fast?

module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!"
  end
end

class Car
  def go_slow
    puts "I am safe and driving slow."
  end
end

class Truck
  def go_very_slow
    puts "I am a heavy truck and like going very slow."
  end
end

=> we can include the module Speed in the Car and Truck classes, which will
give them the functionality for go_fast.  To check, we can instantiate a car
object and a truck object and then call the method go_fast on both objects:
=end

module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!"
  end
end

class Car
  include Speed
  def go_slow
    puts "I am safe and driving slow."
  end
end

class Truck
  include Speed
  def go_very_slow
    puts "I am a heavy truck and like going very slow."
  end
end

my_car = Car.new
my_truck = Truck.new

my_car.go_fast
my_truck.go_fast

=begin
3. In the last question we had a module called Speed which contained a go_fast
method. We included this module in the Car class.  When we called the go_fast
method from an instance of the Car class you might have noticed that the string
printed when we go fast includes the name of the type of vehicle we are using.
How is this done?

=> in the go_fast method included with module Speed, the string references
`self.class`; here, `self` refers to the object calling the method, so the
interpolated value is the string equivalent of the class name for the calling
object.

4. If we have a class AngryCat how do we create a new instance of this class?

The AngryCat class might look something like this:

class AngryCat
  def hiss
    puts "Hisssss!!!"
  end
end

=> To create a new instance of the class, assign a variable representing the
new object to the return value of `AngryCat.new`:

=end
class AngryCat
  def hiss
    puts "Hisssss!!!"
  end
end

my_cat = AngryCat.new
my_cat.hiss

=begin
5. Which of these two classes has an instance variable and how do you know?

class Fruit
  def initialize(name)
    name = name
  end
end

class Pizza
  def initialize(name)
    @name = name
  end
end

=> The class Pizza has an instance variable, which is indicated by having the
 variable name start with `@`. In the Fruit#initialize method, name is a
local variable, not an instance variable, and will not be available outside
this method.

solution note: to demonstrate this, we can instantiate objects of each class
and call method #instance_variables on each object to show what instance
variables are included with each:
=end

class Fruit
  def initialize(name)
    name = name
  end
end

class Pizza
  def initialize(name)
    @name = name
  end
end

my_apple = Fruit.new("apple")
my_pizza = Pizza.new("cheese")

puts "apple: #{my_apple.instance_variables}"
puts "pizza: #{my_pizza.instance_variables}"

=begin
6. What could we add to the class below to access the instance variable @volume?

class Cube
  def initialize(volume)
    @volume = volume
  end
end

=> There are several options:
- for read-only access, we could create a getter method or use the
attr_reader method to establish a getter method for @volume.
- for write-only access, we could create a setter method or use the
attr_writer method to establish a setter method for @volume.
- for read and write access, we could create both getter and setter methods
or use method attr_accessor to establish both for @volume.

solution note: there is demonstration of method #instance_variable_get called
 on an object to get the value of an instance varible, though this is not
recommended:
`cube_object.instance_variable_get("@volume")`

7. What is the default return value of to_s when invoked on an object? Where
could you go to find out if you want to be sure?

=> The default return value of to_s when invoked on an object is a string
with the name of the class and an encoding of the object id. This can be
verified by (1) testing it on an object, or (2) viewing the documentation
for Object#to_s, which is inherited by all objects.

8. If we have a class such as the one below:

class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age  = 0
  end

  def make_one_year_older
    self.age += 1
  end
end

You can see in the make_one_year_older method we have used self. What does
self refer to here?

=> Here, `self` refers to the calling object. Its use here is for the purpose
of disambiguation. The statement `age += 1` would be interpreted by Ruby as
assignment to a local variable age, not to instance variable @age, and not a
reference to invocation of the setter method for age set up by the attr_accessor
method. The code here is calling the #age method on the object that is invoking
it.

9. If we have a class such as the one below:

class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age  = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end
end

In the name of the cats_count method we have used self. What does self refer
to in this context?

=> Here, `self` refers to the class Cat. `self.cats_count` is an object
method, which can be called on the class without requiring instantiation of
an object of that class. This can also be written as `Cats.cats_count`.

10. If we have the class below, what would you need to call to create a new
instance of this class.

class Bag
  def initialize(color, material)
    @color = color
    @material = material
  end
end

=> Bag#new with two arguments.

