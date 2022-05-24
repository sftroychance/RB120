=begin
We created a simple BankAccount class with overdraft protection, that does not allow a withdrawal greater than the amount of the current balance. We wrote some example code to test our program. However, we are surprised by what we see when we test its behavior. Why are we seeing this unexpected output? Make changes to the code so that we see the appropriate behavior.

fix =>

The problem is that success is being assigned based on the truthiness of the
expression `self.balance -= amount`, but this expression will return true if
the balance is negative as a result (a negative value does not make the
expression false.) To fix this, we need to set success to true only if the
calculation results in a positive balance.

Per the solution, can use the included `valid_transaction?` method instead of
  `self.balance >= amount`, and we can remove that method call from
`balance=` since that check is being done in `#withdraw`.

Also, we can move the actions in the following `if` statement into the first
`if` statement since it already branches into true and false results.

Further exploration: What will the return value of a setter method be if you mutate its argument in the method body?

The return value of a setter method is always the value of the object that was
passed into the method. Mutating the value of the argument in the setter
method will result in the mutated object being returned from the setter
method. (Demonstrated in test_setter.rb)
=end

class BankAccount
  attr_reader :balance

  def initialize(account_number, client)
    @account_number = account_number
    @client = client
    @balance = 0
  end

  def deposit(amount)
    if amount > 0
      self.balance += amount
      "$#{amount} deposited. Total balance is $#{balance}."
    else
      "Invalid. Enter a positive amount."
    end
  end

  def withdraw(amount)
    # if amount > 0 && self.balance >= amount
    if amount > 0 && valid_transaction?(balance - amount)
      self.balance -= amount
      "$#{amount} withdrawn. Total balance is $#{balance}."
    else
      "Invalid. Enter positive amount less than or equal to current balance ($#{balance})."
    end
  end

  def balance=(new_balance)
    @balance = new_balance
  end

  def valid_transaction?(new_balance)
    new_balance >= 0
  end
end

# Example

account = BankAccount.new('5538898', 'Genevieve')

# Expected output:
p account.balance         # => 0
p account.deposit(50)     # => $50 deposited. Total balance is $50.
p account.balance         # => 50
p account.withdraw(80)    # => Invalid. Enter positive amount less than or equal to current balance ($50).
# Actual output: $80 withdrawn. Total balance is $50.
p account.balance         # => 50