=begin
Unexpected Change

Modify the following code to accept a string containing a first and last name. The name should be split into two instance variables in the setter method, then joined in the getter method to form a full name.

Expected output:

John Doe
=end

class Person
  def name
    "#{first_name} #{last_name}"
  end

  def name=(name)
    @first_name, @last_name = name.split
  end

  private

  attr_reader :first_name, :last_name
end

person1 = Person.new
person1.name = 'John Doe'
puts person1.name
