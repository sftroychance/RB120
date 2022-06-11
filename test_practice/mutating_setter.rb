class MyClass
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def name=(name)
    name << "!!"
    @name = name
    puts name
  end
end

me = MyClass.new("Troy")

puts me.name
me.name = 'Jason'