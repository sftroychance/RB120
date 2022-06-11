class MeMyselfAndI
  puts self

  def self.me
    puts self
  end

  def myself
    puts self
  end
end

i = MeMyselfAndI.new

i.myself
MeMyselfAndI.me
