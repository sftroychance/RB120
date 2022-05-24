=begin
You started writing a very basic class for handling files. However, when you begin to write some simple test code, you get a NameError. The error message complains of an uninitialized constant File::FORMAT.

What is the problem and what are possible ways to fix it?

=> fix

The `#to_s` method being used by the derived classes is defined in
`File`, and that method references constant `FORMAT`, but those constants are
 defined only in the derived classes. Because constants have lexical scope
and in this case the constant is being invoked in `File`, Ruby is searching
for the constant in the heirarchy for `File`, which does not include those
subclasses.

To fix this, the constant `FORMAT` must explicitly refer to the constant
defined in the class of the calling object. To do this, we can invoke `self
.class::FORMAT` -> 'self' here refers to the calling object, and `class`
returns the class name of that object; the `::` operator is a constant
resolution operator. This statement will return the `FORMAT` constant defined
 within the class of the calling object.

Per the solution, an alternative would be to define method #format in each of
 the derived classes that will return the value of the constant and call that
 method within #to_s instead of referring to the constant directly.
=end

class File
  attr_accessor :name, :byte_content

  def initialize(name)
    @name = name
  end

  alias_method :read,  :byte_content
  alias_method :write, :byte_content=

  def copy(target_file_name)
    target_file = self.class.new(target_file_name)
    target_file.write(read)

    target_file
  end

  def to_s
    "#{name}.#{self.class::FORMAT}"
  end
end

class MarkdownFile < File
  FORMAT = :md
end

class VectorGraphicsFile < File
  FORMAT = :svg
end

class MP3File < File
  FORMAT = :mp3
end

# Test

blog_post = MarkdownFile.new('Adventures_in_OOP_Land')
blog_post.write('Content will be added soon!'.bytes)

copy_of_blog_post = blog_post.copy('Same_Adventures_in_OOP_Land')

puts copy_of_blog_post.is_a? MarkdownFile     # true
puts copy_of_blog_post.read == blog_post.read # true

puts blog_post