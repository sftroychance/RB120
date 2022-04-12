=begin
Using the following code, add the appropriate accessor methods so that @name is returned with the added prefix 'Mr.'.

Expected output:

Mr. James
=end

class Person
  attr_writer :name

  def name
    'Mr. ' + @name
  end
end

person1 = Person.new
person1.name = 'James'
puts person1.name

