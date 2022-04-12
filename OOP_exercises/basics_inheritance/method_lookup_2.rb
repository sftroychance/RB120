=begin
Using the following code, determine the lookup path used when invoking
cat1.color. Only list the classes and modules that Ruby will check when
searching for the #color method.

The color method will not be located since it is not defined in any class or
module in the path, but the path it searches:
[Cat, Animal, Object, Kernal, BasicObject]

=end

class Animal
end

class Cat < Animal
end

class Bird < Animal
end

cat1 = Cat.new
cat1.color
