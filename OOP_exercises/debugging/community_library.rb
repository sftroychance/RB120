=begin
On line 42 (47 here) of our code, we intend to display information regarding
the books currently checked in to our community library. Instead, an exception
is raised. Determine what caused this error and fix the code so that the data
is displayed as expected.

=> The fix
#display_data is begin called on the array books, which is incorrect. The fix
 is to call #display_data on each element of that array.

Alternatively, the solution recommends creating a display method in Library
to do the same thing, in keeping with the Law of Demeter. This solution
allows us to move the attr_accessor for @books to a private attr_reader.

=end

class Library
  attr_accessor :address, :phone

  def initialize(address, phone)
    @address = address
    @phone = phone
    @books = []
  end

  def check_in(book)
    books.push(book)
  end

  def display_book_data
    books.each(&:display_data)
  end

  private

  attr_reader :books
end

class Book
  attr_accessor :title, :author, :isbn

  def initialize(title, author, isbn)
    @title = title
    @author = author
    @isbn = isbn
  end

  def display_data
    puts "---------------"
    puts "Title: #{title}"
    puts "Author: #{author}"
    puts "ISBN: #{isbn}"
    puts "---------------"
  end
end

community_library = Library.new('123 Main St.', '555-232-5652')
learn_to_program = Book.new('Learn to Program', 'Chris Pine', '978-1934356364')
little_women = Book.new('Little Women', 'Louisa May Alcott', '978-1420951080')
wrinkle_in_time = Book.new('A Wrinkle in Time', 'Madeleine L\'Engle', '978-0312367541')

community_library.check_in(learn_to_program)
community_library.check_in(little_women)
community_library.check_in(wrinkle_in_time)

# community_library.books.display_data
# `community_library.books.each(&:display_data)
community_library.display_book_data
