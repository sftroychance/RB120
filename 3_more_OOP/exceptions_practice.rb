# begin
#   puts 1 / 0
#   puts arr[0]
# rescue ZeroDivisionError => detail
#   puts detail.message
#   puts detail.backtrace
#   puts detail.class
# rescue StandardError => detail
#   puts "other error"
#   puts detail.message
#   puts detail.class
# end
#

# if you do not define an object with the rescue block, Ruby provides variables
# to access them $! for the object, $@ for its backtrace
begin
  puts 1 / 0
rescue
  puts $!.message
  puts $!.class
  puts $@
  puts $!.backtrace
end

arr = [1, 2, 3]

# begin
#   raise("not in array") unless arr[3]
# rescue RuntimeError => detail
#   puts detail.message
# end

# def err_test(arr)
#   raise("not in array") unless arr[3]
#   puts arr[3]
# end
#
# begin
#   err_test(arr)
# rescue RuntimeError => detail
#   puts detail.message
#   puts detail.class
# end

# class ValidateAgeError < StandardError
# end
#
# age = 130
#
# def validate_age(age)
#   raise ValidateAgeError, "invalid age" unless (0..105).include?(age)
# end
#
# begin
#   validate_age(age)
# rescue ValidateAgeError => e
#   puts e.message
#   puts e.backtrace
#   puts e.class
# end
