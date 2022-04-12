=begin
Using the following code, determine the lookup path used when invoking
cat1.color. Only list the classes that were checked by Ruby when searching for
the #color method.

The lookup path used when invoking cat1.color is [Cat,  Animal]; that is not the
full lookup path, only the lookup path up to the point where the method is
located.
=end

class Animal
  attr_reader :color

  def initialize(color)
    @color = color
  end
end

class Cat < Animal
end

class Bird < Animal
end

cat1 = Cat.new('Black')
cat1.color
