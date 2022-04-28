module Mod
  # MY_CONST = 5
  def tryme
    puts MY_CONST
    puts Module.nesting
    puts Mod.ancestors
  end

  module ModMod
    def trythis
      puts MY_CONST
      puts Module.nesting
      puts ModMod.ancestors
    end
  end
end

class MyClass
  include Mod
  include ModMod

  #MY_CONST = 5
  def initialize
    tryme
    trythis
    puts MY_CONST
  end
end

MY_CONST = 5

MyClass.new

=begin
verifying:
if constant is defined at top level, Ruby will be able to access it from
within any class or module.

If constant is defined at the module level, all methods of that module and
all submodules can access it, and methods of any class that includes the module
can access it.

If constant is defined at the class level, the methods of any included
modules cannot access it directly because it is not in the module's
hierarchy; but it can be accessed by using `self.class::MY_CONST` because
here self refers to the object of the class that includes the module.

The order of lookup for constants:
1. lexical - where it is referenced and any enclosing classes/modules of that
 location
2. hierarchical - ancestors (like method lookup)
3. top-level
=end