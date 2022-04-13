=begin
Write a class that will display:

ABC
xyz

with these method calls:
my_data = Transform.new('abc')
puts my_data.uppercase
puts Transform.lowercase('XYZ')
=end

class Transform
  def initialize(data)
    @data = data
  end

  def uppercase
    data.upcase
  end

  def self.lowercase(str)
    str.downcase
  end

  private

  attr_reader :data
end

my_data = Transform.new('abc')
puts my_data.uppercase
puts Transform.lowercase('XYZ')
