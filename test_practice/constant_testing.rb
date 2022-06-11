module TCG
  #MY_CONST = 'In module TCG'

  module TCGG
     # MY_CONST = 'IN TCGG'
    def const
      puts MY_CONST
      p Module.nesting
      p self.class.ancestors
    end

    class Troy_troy
      def const
        p Module.nesting
        puts MY_CONST
      end
    end
  end

  class TCG_troy
    def const
      p Module.nesting
      puts MY_CONST
    end
  end
end

MY_CONST = 'In main'
class Troy
  # MY_CONST = 'In class Troy'
  include TCG

  def const
    p Module.nesting
    p self.class.ancestors
    puts MY_CONST
  end
end

class Bob < Troy
  MY_CONST = 'In Class Bob'
end

class Boy < Troy
  MY_CONST = 'in class Boy'
  include TCG
  def const
    puts MY_CONST
  end

end

class Me
  include TCG::TCGG

end

class A
  CC = "howdy"

  def get_cc
    self.class::CC
  end
end

class B < A
  CC = 'hi'
end



troy = Troy.new
bob = Bob.new
boy = Boy.new

troy.const
bob.const
boy.const

me = Me.new
me.const

p Bob.const_get(:MY_CONST)
puts Bob::MY_CONST

v = TCG::TCG_troy.new
v.const

x = TCG::TCGG::Troy_troy.new
puts x.const
# => lexical scope is all the way up to the top enclosing module
# or class
#
a = A.new
p a.get_cc

b = B.new
p b.get_cc

puts A::CC