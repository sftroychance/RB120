=begin
Modify the following code so that Hello! I'm a cat! is printed when Cat.generic_greeting is invoked.

Expected output:

Hello! I'm a cat!
=end

class Cat
  def self.generic_greeting
    puts "Hello! I'm a cat!"
  end
end

Cat.generic_greeting

kitty = Cat.new
kitty.class.generic_greeting

=begin
What happens if you run kitty.class.generic_greeting? Can you explain this result?

The result is the same as if we had called the method on the class, because
kitty#class is returning a reference to the class.
=end
