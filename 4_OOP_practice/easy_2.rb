=begin
1. You are given the following code:

class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end

What is the result of executing the following code:

oracle = Oracle.new
oracle.predict_the_future

=> This will return the string 'You will ' followed by one of teh three array
choices given in method Oracle#choices. Method #sample returns a random value
 from the array it is called on.

2. We have an Oracle class and a RoadTrip class that inherits from the Oracle
class.

class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end

class RoadTrip < Oracle
  def choices
    ["visit Vegas", "fly to Fiji", "romp in Rome"]
  end
end

What is the result of the following:

trip = RoadTrip.new
trip.predict_the_future

=> This will return a string starting with 'You will ' and followed by one
of the three array choices given in the Roadtrip#choices method. The method
#predict_the_future is inherited from Oracle, but method #choices is
overridden in RoadTrip, and that is the method that will be invoked by calling
#choices within a RoadTrip object.

3. How do you find where Ruby will look for a method when that method is called?
How can you find an object's ancestors?

=> When looking for a method, Ruby will first search the current class, and then
it will search any included modules (in reverse order of include statements),
then parent classes and their modules, including Object, Kernel, and
BasicObject. To view an object's ancestors, you can call the #ancestors
method on the object.

module Taste
  def flavor(flavor)
    puts "#{flavor}"
  end
end

class Orange
  include Taste
end

class HotSauce
  include Taste
end

What is the lookup chain for Orange and HotSauce?

=> Orange: [Orange, Taste, Object, Kernel, BasicObject]

HotSauce: [HotSauce, Taste, Object, Kernel, BasicObject]

solution note: if the method is not found in the lookup path, Ruby will raise
a NoMethodError.

4. What could you add to this class to simplify it and remove two methods from
the class definition while still maintaining the same functionality?

class BeesWax
  def initialize(type)
    @type = type
  end

  def type
    @type
  end

  def type=(t)
    @type = t
  end

  def describe_type
    puts "I am a #{@type} of Bees Wax"
  end
end

=> If you add the attr_accessor method, as follows, you can remove the methods
#type and #type=:

class BeesWax
  attr_accessor :type

  def initialize(type)
    @type = type
  end

  def describe_type
    puts "I am a #{@type} of Bees Wax"
  end
end

solution note: Here, it would also be standard practice to change `@type` in the
#describe_type method to `type`, as it is better to use the getter and setter
methods, if they are available, within instance methods (except #initialize).

5. There are a number of variables listed below. What are the different types
and how do you know which is which?

excited_dog = "excited dog"
@excited_dog = "excited dog"
@@excited_dog = "excited dog"

=> `excited_dog` is a local variable, which is indicated by having all lowercase
letters (snake case). `@excited_dog` is an instance variable, indicated in that
it has all lowercase letters and is prefixed with a single `@`.
`@@excited_dog` is a class variable, as indicated by having all lowercase
letters and the prefix of `@@`.

6. If I have the following class:

class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end

Which one of these is a class method (if any) and how do you know? How would
you call a class method?

=> Here, the class method is Television#manufacturer.  It is defined as a class
method because the method name has `self.` prefixed. A class method is called
 on the class itself, so in this case: `Television.manufacturer`.

7. If we have a class such as the one below:

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

Explain what the @@cats_count variable does and how it works. What code would
you need to write to test your theory?

=> The @@cats_count variable is a class variable, which means it is
accessible to all objects instantiated for Cat (as well as all objects
 of any subclasses of Cat). The variable is shared by all those objects, so
any change to it made by any object will be duplicated in all objects. Cat is
 defined such that any time a new Cat object is instantiated (which results
in the #initialize method being executed), the @@cats_count variable is
incremented by one; this variable tracks the total number of cat objects that
 are created in the program.

Here, to test:
Cat.cats_count # => 0
my_cat = Cat.new('hairless')
Cat.cats_count # => 1
Cat.new('fluffy')
Cat.cats_count # => 2

8. If we have this class:

class Game
  def play
    "Start the game!"
  end
end

And another class:

class Bingo
  def rules_of_play
    #rules of play
  end
end

What can we add to the Bingo class to allow it to inherit the play method 
from the Game class?

=> We could make Bingo a subclass of Game by showing inheritance in the Bingo 
class definition:
`class Bingo < Game`

9. If we have this class:

class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game
  def rules_of_play
    #rules of play
  end
end

What would happen if we added a play method to the Bingo class, keeping in
mind that there is already a method of this name in the Game class that the
Bingo class inherits from.

=> If we add a #play method to the Bingo class, the Bingo object will call that
version of the method instead of the Game class version of the method; it has
 been overridden.

10. What are the benefits of using Object Oriented Programming in Ruby? Think
of as many as you can.

1. Encapsulation: bundling of attributes and behavior that hides and protects
 both.  This isolates data and methods from the larger set of code,
preventing access where it is not authorized by explicitly defined interfaces
 and keeping anyone who does not have access to the class from changing its
code.
2. Polymorphism: the ability of objects of different types (classes) to
respond to the same interface or for a single reference to represent multiple
data types. This simplifies calling methods on objects whose types might not
all be known until runtime or who have individualized actions to a shared
behavior or description of behavior.
3. Inheritance: the ability to create new classes that use the behavior of a
parent class or behavior included in a module, which often prevents having to
completely redefine those methods when new classes are created.
4. Abstraction: the establishment of a baseline level of complexity below
which the details are suppressed. This facilitates design and troubleshooting
 by allowing developers to focus only on the concepts necessary to working
through a problem without having to keep track of details that are not
germane to those concepts. This facilitates the establishment of useful mental
 models.
5. Simplifies troubleshooting: Just in the examples we have worked through so
 far in the lessons (particularly RPS), having the code segregated into
discrete logical units helps narrow down where a problem is occurring (as
opposed to having to search a larger and more complex single body of code).
6. Focuses attention on how users interact with the code. With OOP, we are
thinking in terms of interfaces to the classes we create, so we give
attention to how those interfaces can be most easily used and understood by
other users (and ourselves at a later date).
7. Facilitates changes to code that do not break the program. If an update is
 necessary for particular functionality, changes are often isolated to
certain sections of code (particular classes or modules); other sections of
code don't need to be changed as long as their interface to the affected code
 remains the same, or such changes can be minimized, reducing errors that can
 be introduced into the code.

given solution (note the more concise wording!)

Creating objects allows programmers to think more abstractly about the code they
are writing.
Objects are represented by nouns so are easier to conceptualize.
It allows us to only expose functionality to the parts of code that need it,
meaning namespace issues are much harder to come across.
It allows us to easily give functionality to different parts of an application
without duplication.
We can build applications faster as we can reuse pre-written code.
As the software becomes more complex this complexity can be more easily managed.