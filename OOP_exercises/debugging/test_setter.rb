=begin
verifying that if the value passed to a setter method is mutated within the
method, the setter method will return the mutated value.
=end

class SetterTest
  def name=(name)
    @name = name.upcase!
  end

  def name
    @name
  end
end

test = SetterTest.new
puts test.name = "Troy"
puts test.name