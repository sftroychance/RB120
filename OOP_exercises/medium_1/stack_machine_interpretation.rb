=begin
You may remember our Minilang language from back in the RB101-RB109
Medium exercises. We return to that language now, but this time we'll be using
OOP. If you need a refresher, refer back to that exercise.

Write a class that implements a miniature stack-and-register-based programming
language that has the following commands:

n Place a value n in the "register". Do not modify the stack.
PUSH Push the register value on to the stack. Leave the value in the register.
ADD Pops a value from the stack and adds it to the register value, storing the result in
the register.
SUB Pops a value from the stack and subtracts it from the register value,
storing the result in the register.
MULT Pops a value from the stack and multiplies it by the register value,
storing the result in the register.
DIV Pops a value from the stack and divides it into the register
value, storing the integer result in the register.
MOD Pops a value from the stack and divides it into the register value, storing
the integer remainder of the division in the register.
POP Remove the topmost item from the stack and place in register
PRINT Print the register value

All operations are integer operations (which is only important with DIV and MOD).

Programs will be supplied to your language method via a string passed in as an
argument. Your program should produce an error if an unexpected item is present
in the string, or if a required stack value is not on the stack when it should
be (the stack is empty). In all error cases, no further processing should be
performed on the program.

You should initialize the register to 0.

Further exploration:
- Passing parameters implemented, multiple parameters processed using `*args`.
Added `@formatted_program` to convert the program before tokenizing if args
are present (cannot change @program directly since the it must stay the same for
all `eval` calls.

- Did not need to make a change for simplifying `stack_pop` as this is
already an intermediary method that is called anytime a value needs
to be popped from the stack (e.g., `stack_to_register` and the operations.

Note that the hint given to use Object#send I interpreted as using send to
call the method for the operator corresponding to the token (as opposed to
having a method for every operation).

The solution has the two desired error classes subclass from another, but
my choice was to rescue both the errors instead of that superclass.

=end

class InvalidTokenError < StandardError
end

class EmptyStackError < StandardError
end

class Minilang
  TOKENS = %w(ADD SUB MULT DIV MOD PUSH PRINT POP)
  OPERATORS = { 'ADD' => '+',
                'SUB' => '-',
                'MULT' => '*',
                'DIV' => '/',
                'MOD' => '%' }

  def initialize(program)
    @program = program
  end

  def eval(*args)
    @register = 0
    @stack = []

    @formatted_program =
      args ? format_arguments(args) : @program

    tokenize_program

    process_tokens

  rescue InvalidTokenError, EmptyStackError => detail
    puts detail.message
  end

  private

  def format_arguments(args)
    @formatted_program = format(@program, *args)
  end

  def tokenize_program
    @tokens = @formatted_program.split
  end

  def process_tokens
    @tokens.each do |token|
      if token =~ /^[+-]?\d+$/
        @register = token.to_i
        next
      end

      validate_token(token)

      execute_token(token)
    end
  end

  def validate_token(token)
    if !TOKENS.include?(token)
      raise InvalidTokenError, "Invalid token: #{token}"
    end
  end

  def execute_token(token)
    case token
    when 'PUSH' then register_to_stack
    when 'POP' then stack_to_register
    when 'PRINT' then print_register
    else perform_operation(token)
    end
  end

  def pop_stack
    raise EmptyStackError, "Empty stack!" if @stack.empty?

    @stack.pop
  end

  def perform_operation(token)
    @register = @register.send(OPERATORS[token], pop_stack)
  end

  def print_register
    puts @register
  end

  def register_to_stack
    @stack << @register
  end

  def stack_to_register
    @register = pop_stack
  end
end

Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# 5
# 3
# 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# 10
# 5

Minilang.new('5 PUSH POP POP PRINT').eval
# Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# 12

Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# 8

Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)
#
CENTIGRADE_TO_FAHRENHEIT =
  '5 PUSH %<degrees_c>d PUSH 9 MULT DIV PUSH 32 ADD PRINT'
minilang = Minilang.new(CENTIGRADE_TO_FAHRENHEIT)
minilang.eval(degrees_c: 100)
# 212
minilang.eval(degrees_c: 0)
# 32
minilang.eval(degrees_c: -40)
# -40
#
FARENHEIT_TO_CENTIGRADE =
  '9 PUSH 5 PUSH 32 PUSH %<degrees_f>d SUB MULT DIV PRINT'
minilang = Minilang.new(FARENHEIT_TO_CENTIGRADE)
minilang.eval(degrees_f: 212)
# 100
minilang.eval(degrees_f: 32)
# 0
minilang.eval(degrees_f: -40)
# -40
#
MPH_TO_KPH =
  '3 PUSH 5 PUSH %<mph>d MULT DIV PRINT'
minilang = Minilang.new(MPH_TO_KPH)
minilang.eval(mph: 10)
# 16
minilang.eval(mph: 20)
# 32
#
RECTANGLE_AREA =
  '%<width>d PUSH %<height>d MULT PRINT'
minilang = Minilang.new(RECTANGLE_AREA)
minilang.eval(width: 10, height: 10)
# 100
minilang.eval(width: 25, height: 30)
# 750

