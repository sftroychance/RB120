=begin
Complete this program so that it produces the expected output:

Expected output:

The author of "Snow Crash" is Neil Stephenson.
book = "Snow Crash", by Neil Stephenson.
=end

class Book
  attr_reader :author, :title

  def initialize(author, title)
    @author = author
    @title = title
  end

  def to_s
    %("#{title}", by #{author})
  end

  def reader
    puts @author.object_id
    @author
  end
end

book = Book.new("Neil Stephenson", "Snow Crash")
puts %(The author of "#{book.title}" is #{book.author}.)
puts %(book = #{book}.)
author = book.reader
puts author.object_id
book.reader.upcase! # Warning: this mutates the object referenced by the instance variable in the class!
puts book.author

=begin
Further Exploration

What are the differences between attr_reader, attr_writer, and attr_accessor?
Why did we use attr_reader instead of one of the other two? Would it be okay to
use one of the others? Why or why not?

Instead of attr_reader, suppose you had added the following methods to this class:

def title
  @title
end

def author
  @author
end
Would this change the behavior of the class in any way? If so, how? If not, why
not? Can you think of any advantages of this code?

attr_reader provides a getter for the instance variables so declared, which we
require in this case because the user is accessing those variables.

attr_writer provides a setter, and attr_accessor provides both a getter
and a setter.  We should not use these because write access to the instance
variables is not required for the user (at least for the given example code),
and we should expose only the interface that is required by the user, no more
than that.

The two added methods replace what is being done by attr_reader, so the behavior
of the class would not be changed by writing these methods instead. The advantage
of writing out the getter methods is that we can apply additional formatting to
the values if that is needed by the user (or by the instance methods, if the getters
were private methods).

In interesting detail (reviewing other solutions): When a getter returns the instance
variable, it is returning the object, not just the value, so the user can mutate
the instance variable from outside the class. To prevent mutability, we might want to
return a duplicate value of the instance variable.
=end

