=begin

If we have this code:

class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

What happens in each of the following cases:

hello = Hello.new
hello.hi

=> this will display "Hello"

hello = Hello.new
hello.bye

=> this will result in NoMethodError; method #bye is defined in class Goodbye
 but not in class Hello and not in class Greeting, so class Hello doesn't
have access to it.

hello = Hello.new
hello.greet

=> This will result in ArgumentError because the method #greet, inherited
from the Greeting class, requires an argument.

hello = Hello.new
hello.greet("Goodbye")

=> This will display "Goodbye"

Hello.hi

=> This will result in NoMethodError, because a class method #hi has not been
 written for class Hello, only an instance method #hi, which must be called
on an object of the class.

2. In the last question we had the following classes:

class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

If we call Hello.hi we get an error message. How would you fix this?

=> We could change the instance method Hello#hi to a class method by
prepending `self.` to the name, as follows:
`def self.hi`

If we want to keep the instance method Hello#hi, we can write a new method
`self.hi` with the desired functionality.

We could also define a method `self.hi` in the greeting class, which would be
 inherited by Hello, and the instance method Hello#hi would not override that.

solution note: the official solution goes on to define functionality for
`self.hi`, pointing out that calling any instance method within that class
method would require instantiating an object.

class Hello
  def self.hi
    greeting = Greeting.new
    greeting.greet("Hello")
  end
end

A Greeting object is created, but a Hello object could be created as well;
the important thing is that an object has to be instantiated to call the
#greet method from the class method.

3. When objects are created they are a separate realization of a particular
class.

Given the class below, how do we create two different instances of this class
with separate names and ages?

class AngryCat
  def initialize(age, name)
    @age  = age
    @name = name
  end

  def age
    puts @age
  end

  def name
    puts @name
  end

  def hiss
    puts "Hisssss!!!"
  end
end

=> instantiate two objects of the class with the appropriate arguments:

my_cat = AngryCat.new(10, 'Fluffy')
your_cat = AngryCat.new(3, 'Snowball')

4. Given the class below, if we created a new instance of the class and then
called to_s on that instance we would get something like
"#<Cat:0x007ff39b356d30>"

class Cat
  def initialize(type)
    @type = type
  end
end

How could we go about changing the to_s output on this method to look like this:
I am a tabby cat? (this is assuming that "tabby" is the type we passed in during
initialization).

=> we would define a to_s method in Cat that returns the desired string value.
An attr_reader method is added here to establish a getter for @type since
it is being referenced in a method.

class Cat
  attr_reader :type

  def initialize(type)
    @type = type
  end

  def to_s
    "I am a #{type} cat."
  end
end

5. If I have the following class:

class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end

What would happen if I called the methods like shown below?

tv = Television.new
# => a new Television object is created and its reference assigned to variable
`tv`

tv.manufacturer
# => NoMethodError - #manufacturer is a class method and cannot be called on an
object

tv.model
# => the method logic for instance method Television#model would execute

Television.manufacturer
# => the method logic for class method Television#manufacturer would execute

Television.model
# => NoMethodError - Television#model is an instance method and is not defined
for the class; an object must be instantiated and the method called on that
object

6. If we have a class such as the one below:

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

In the make_one_year_older method we have used self. What is another way we
could write this method so we don't have to use the self prefix?

=> Instead of `self.age` += 1, we could access the instance variable directly:
`@age += 1`, though this is not considered the best practice when a setter
method is defined.

7. What is used in this class but doesn't add any value?

class Light
  attr_accessor :brightness, :color

  def initialize(brightness, color)
    @brightness = brightness
    @color = color
  end

  def self.information
    return "I want to turn on the light with a brightness level of super high and a color of green"
  end
end

=> Setter and getter methods are established for @brightness and @color, but
they are not used in the class as written (unless they are intended to allow
read/write access to those instance variables as method calls on the object).

In `self.information`, the return keyword is unnecessary because the method
will implicitly return the string.

