class Person
  attr_accessor :first_name, :last_name

  def initialize(name)
    self.name = name
  end

  def name
    first_name + (last_name.empty? ? '' : ' ' + last_name)
  end

  def ==(other)
    name == other.name
  end

  def name=(full_name)
    parse_name(full_name)
  end

  def to_s
    name
  end

  private

  def parse_name(full_name)
    self.first_name, self.last_name = full_name.split
    self.last_name = '' if last_name.nil?
  end
end

bob = Person.new('Robert Smith')
rob = Person.new('Robert Smith')
p bob == rob
p bob.name == rob.name
puts "The person's name is: #{bob}"

bob = Person.new('Robert')
p bob.name                  # => 'Robert'
p bob.first_name            # => 'Robert'
p bob.last_name             # => ''
bob.last_name = 'Smith'
p bob.name                  # => 'Robert Smith'

bob.name = "John Adams"
p bob.first_name            # => 'John'
p bob.last_name             # => 'Adams'
