class Parent
  attr_accessor :name
end

class ChildA < Parent
  def initialize(name)
    puts name
  end
end

class ChildB < Parent
  def initialize(name)
    puts name
  end
end

class ChildC < Parent
  def initialize(name)
    puts name
  end
end

#random = [ChildA.new, ChildB.new, ChildC.new].sample

# sub_name = ['ChildA', 'ChildB', 'ChildC'].sample
# RandomClass = Object.const_get(sub_name)
# x = RandomClass.new
# p x
#

a = ChildA.new("Sarah")
p a.class

a = ChildB.new("Alfred")
p a.class
