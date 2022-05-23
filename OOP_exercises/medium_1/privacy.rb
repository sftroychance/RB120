=begin
Consider the following class:

class Machine
  attr_writer :switch

  def start
    self.flip_switch(:on)
  end

  def stop
    self.flip_switch(:off)
  end

  def flip_switch(desired_state)
    self.switch = desired_state
  end
end
Modify this class so both flip_switch and the setter method switch= are private methods.

=end

class Machine
  def start
    flip_switch(:on)
  end

  def stop
    flip_switch(:off)
  end

  def switch_status
    switch
  end

  private

  attr_accessor :switch

  def flip_switch(desired_state)
    self.switch = desired_state
  end
end

my_machine = Machine.new
# my_machine.flip_switch(:on)
# => private method `flip_switch' called for #<Machine:0x000000015708b148> (NoMethodError)
#
# my_machine.switch = :on
# => private method `switch=' called for #<Machine:0x000000015598ed28>

my_machine.start
my_machine.stop

=begin
Further exploration: Add a private getter for @switch to the Machine class, and
add a method to Machine that shows how to use that getter.

-> converted `attr_writer :switch` to `attr_accessor :switch`

-> added method `switch_status` to get the value of the switch.
=end

puts my_machine.switch_status
my_machine.start
puts my_machine.switch_status
