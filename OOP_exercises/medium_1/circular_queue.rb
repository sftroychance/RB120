=begin
A circular queue is a collection of objects stored in a buffer that is treated
as though it is connected end-to-end in a circle. When an object is added to
this circular queue, it is added to the position that immediately follows the
most recently added object, while removing an object always removes the object
that has been in the queue the longest.

This works as long as there are empty spots in the buffer. If the buffer becomes
full, adding a new object to the queue requires getting rid of an existing
object; with a circular queue, the object that has been in the queue the longest
is discarded and replaced by the new object.

Your task is to write a CircularQueue class that implements a circular queue for
arbitrary objects. The class should obtain the buffer size with an argument
provided to CircularQueue::new, and should provide the following methods:

enqueue to add an object to the queue dequeue to remove (and return) the oldest
object in the queue. It should return nil if the queue is empty.  You may assume
that none of the values stored in the queue are nil (however, nil may be used to
designate empty spots in the buffer).

NOTES:
With Benchmarking, discovered that:
1 - using #push to enqueue and #shift to dequeue is faster than the opposite.
2 - checking the size of @queue before doing #push is faster than checking after.
3 - using << is faster than using #push
=end

class CircularQueue
  def initialize(size)
    @buffer_size = size
    @queue = Array.new
  end

  def enqueue(value)
    # dequeue if @queue.size == @buffer_size

    # @queue.push(value)
    @queue << value

    dequeue if @queue.size > @buffer_size
  end

  def dequeue
    @queue.shift
  end

  def start_enqueue(value)
    # dequeue if @queue.size == @buffer_size

    @queue.unshift(value)

    dequeue if @queue.size > @buffer_size
  end

  def end_dequeue
    @queue.pop
  end
end

require 'benchmark'

n = 10000000

Benchmark.bm do |x|
  x.report("enqueue at end") do
    queue = CircularQueue.new(3)
    n.times do
      queue.enqueue(1)
      queue.enqueue(2)
      queue.dequeue
      queue.enqueue(3)
      queue.enqueue(4)
      queue.dequeue
      queue.enqueue(5)
      queue.enqueue(6)
      queue.enqueue(7)
      queue.dequeue
      queue.dequeue
      queue.dequeue
    end
  end

  x.report("enqueue at beg") do
    queue = CircularQueue.new(3)
    n.times do
      queue.start_enqueue(1)
      queue.start_enqueue(2)
      queue.end_dequeue
      queue.start_enqueue(3)
      queue.start_enqueue(4)
      queue.end_dequeue
      queue.start_enqueue(5)
      queue.start_enqueue(6)
      queue.start_enqueue(7)
      queue.end_dequeue
      queue.end_dequeue
      queue.end_dequeue
    end
  end
end


queue = CircularQueue.new(3)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil

queue = CircularQueue.new(4)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 4
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil
