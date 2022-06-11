class A
  def initialize
    @name = "A name"
  end

  def +(other)
    name + ' ' + other.name
  end

  protected
  attr_reader :name
end

class B < A
  def initialize
    @name = 'B name'
  end

  def +(other)
    name + ' ' + other.name
  end
end

a = A.new
b = B.new
puts a + b

puts a.is_a?(B)
puts b + a

puts b.is_a?(A)