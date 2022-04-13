=begin
Modify this code so it works. Do not make the amount in the wallet accessible to
any method that isn't part of the Wallet class.

class Wallet
  include Comparable

  def initialize(amount)
    @amount = amount
  end

  def <=>(other_wallet)
    amount <=> other_wallet.amount
  end
end

bills_wallet = Wallet.new(500)
pennys_wallet = Wallet.new(465)
if bills_wallet > pennys_wallet
  puts 'Bill has more money than Penny'
elsif bills_wallet < pennys_wallet
  puts 'Penny has more money than Bill'
else
  puts 'Bill and Penny have the same amount of money.'
end

=> Add a protected attr_reader for @amount; protected
will keep @amount private outside the class but will
allow an object to call it from within the class.
=end

class Wallet
  include Comparable

  def initialize(amount)
    @amount = amount
  end

  def <=>(other_wallet)
    self.amount <=> other_wallet.amount
  end

  protected

  attr_reader :amount
end

bills_wallet = Wallet.new(500)
pennys_wallet = Wallet.new(465)
if bills_wallet > pennys_wallet
  puts 'Bill has more money than Penny'
elsif bills_wallet < pennys_wallet
  puts 'Penny has more money than Bill'
else
  puts 'Bill and Penny have the same amount of money.'
end

p bills_wallet.send(:amount)
p bills_wallet

=begin
Further exploration

This example is rather contrived and unrealistic, but this type of situation
occurs frequently in applications. Can you think of any applications where
protected methods would be desirable?

=> Any application where comparisons need to be made on
data that must remain private (as in this situation); any
application that will require other operator functions
with hidden data.
=end
