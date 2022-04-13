=begin
What will the following code print?

class Something
  def initialize
    @data = 'Hello'
  end

  def dupdata
    @data + @data
  end

  def self.dupdata
    'ByeBye'
  end
end

thing = Something.new
puts Something.dupdata
puts thing.dupdata

=> On line 18, a `Something` object is instantiated and its reference is
assigned to variable `thing`.
On line 19, method #dupdata is called on class Something; this is defined
in the class as method `self.dupdata` and will return 'ByeBye'; this is sent
as an argument to the puts method and is output.
On line 20, method #dupdata is called on the object `thing`. Within the
`Something` class, instance method #dupdata is defined and will return 'HelloHello'.
Thus, the following will be printed to the screen:
ByeBye
HelloHello

=end

class Something
  def initialize
    @data = 'Hello'
  end

  def dupdata
    @data + @data
  end

  def self.dupdata
    'ByeBye'
  end
end

thing = Something.new
puts Something.dupdata
puts thing.dupdata


