=begin
Complete this program so that it produces the expected output:

Expected output:

The author of "Snow Crash" is Neil Stephenson.
book = "Snow Crash", by Neil Stephenson.
=end

class Book
  attr_accessor :title, :author

  def to_s
    %("#{title}", by #{author})
  end
end

book = Book.new
book.author = "Neil Stephenson"
book.title = "Snow Crash"
puts %(The author of "#{book.title}" is #{book.author}.)
puts %(book = #{book}.)

=begin
Further Exploration

What do you think of this way of creating and initializing Book objects? (The
two steps are separate.) Would it be better to create and initialize at the same
time like in the previous exercise? What potential problems, if any, are
introduced by separating the steps?

It seems it would be better to initialize the instance variables in the
constructor, because part of the function of an object is to maintain state. In
this example, a book without a title or author isn't particularly useful as an
object. This method of initializing might be appropriate if, for instance, 'stateless' book
objects are being created as default values for a hash, or if the .new method is
being invoked on classes that are not known at runtime (though I don't know at this
point if that is typical or useful). Also (again not knowing at this point), there might be
some advantage to allocating space for an object without initializing its state.
=end
