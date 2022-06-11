module Troy
  MY_CONST = "x"

  class Character
    attr_accessor :name, :test_variable

    def initialize(name)
      @name = name
    end

    def speak
      puts "#{name} is speaking."
      puts MY_CONST
      puts self.class
      puts self
    end
  end

  class Knight < Character
    def name
      "Sir " + super
    end
  end

  def self.say_hi
    puts 'howdy'
    puts MY_CONST
    puts "class"
    puts self.class
  end

  module B
    def self.say_hi
      puts MY_CONST
      puts "hey"
      puts self.class.ancestors
      puts Object.ancestors

      puts self.class
    end
  end
end

class A
  # include Troy

end
sir_gallant = Troy::Knight.new("Gallant")
puts sir_gallant.name # => "Sir Gallant"
puts sir_gallant.speak # => "Sir Gallant is speaking."

p sir_gallant

p sir_gallant.instance_variables

alloc_knight = Troy::Knight.allocate
alloc_knight.send :initialize, 'Troy'
p alloc_knight.instance_variables
p alloc_knight