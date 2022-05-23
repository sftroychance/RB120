=begin
A fixed-length array is an array that always has a fixed number of elements.
Write a class that implements a fixed-length array, and provides the necessary
methods to support the following code:

fixed_array = FixedArray.new(5)
puts fixed_array[3] == nil
puts fixed_array.to_a == [nil] * 5

fixed_array[3] = 'a'
puts fixed_array[3] == 'a'
puts fixed_array.to_a == [nil, nil, nil, 'a', nil]

fixed_array[1] = 'b'
puts fixed_array[1] == 'b'
puts fixed_array.to_a == [nil, 'b', nil, 'a', nil]

fixed_array[1] = 'c'
puts fixed_array[1] == 'c'
puts fixed_array.to_a == [nil, 'c', nil, 'a', nil]

fixed_array[4] = 'd'
puts fixed_array[4] == 'd'
puts fixed_array.to_a == [nil, 'c', nil, 'a', 'd']
puts fixed_array.to_s == '[nil, "c", nil, "a", "d"]'

puts fixed_array[-1] == 'd'
puts fixed_array[-4] == 'c'

begin
  fixed_array[6]
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[-7] = 3
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[7] = 3
  puts false
rescue IndexError
  puts true
end

The above code should output true 16 times.

A:
class FixedArray
- instance variable @array_size
- method [] to retrieve value
- method []= to set value
  - check range of index -array_size to (array_size - 1)
  - return value if in range
  - if not in range, raise an index error

NOTES:
- Did not use clone when returning the array; this allows the array to be mutated
by any user calling the method
- Instead of raising IndexError, can use Array#fetch, which will return
IndexError if it is out of range, so a range doesn't even need to be given here.
=end

class FixedArray
  def initialize(size)
    @array_size = size
    @array = [nil] * size
    # also: @array = Array.new(size)
  end

  def to_a
    @array.clone
  end

  def to_s
    "#{@array}"
  end

  def [](idx)
    # alternative: @array.fetch(index) will raise IndexError
    if in_range?(idx)
      @array[idx]
    else
      raise IndexError
    end
  end

  def []=(idx, value)
    # alternative: self[idx] will raise IndexError
    if in_range?(idx)
      @array[idx] = value
    else
      raise IndexError
    end
  end

  private

  def in_range?(idx)
    idx.between?(-@array_size, @array_size - 1)
  end
end

fixed_array = FixedArray.new(5)
puts fixed_array[3] == nil
puts fixed_array.to_a == [nil] * 5

fixed_array[3] = 'a'
puts fixed_array[3] == 'a'
puts fixed_array.to_a == [nil, nil, nil, 'a', nil]

fixed_array[1] = 'b'
puts fixed_array[1] == 'b'
puts fixed_array.to_a == [nil, 'b', nil, 'a', nil]

fixed_array[1] = 'c'
puts fixed_array[1] == 'c'
puts fixed_array.to_a == [nil, 'c', nil, 'a', nil]

fixed_array[4] = 'd'
puts fixed_array[4] == 'd'
puts fixed_array.to_a == [nil, 'c', nil, 'a', 'd']
puts fixed_array.to_s == '[nil, "c", nil, "a", "d"]'

puts fixed_array[-1] == 'd'
puts fixed_array[-4] == 'c'

begin
  fixed_array[6]
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[-7] = 3
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[7] = 3
  puts false
rescue IndexError
  puts true
end
