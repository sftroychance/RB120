=begin

We discovered Gary Bernhardt's repository for finding out whether something rocks or not, and decided to adapt it for a simple example.

=> Several issues:

1. Don't inherit from the class Exception because some errors need to crash
the program.

2. NoScore needs to be returned as an object.

3. `rescue Exception` in class Score would rescue all exceptions, including
the one we raised.

4. Remember that Ruby traverses up the call stack to find the first
applicable rescue clause (changing the exception in Score#for_term to
ZeroDivisionError means that clause ignores the AuthenticationError, which is
 then rescued in Score#find_out. If that rescue statement is not there, the
program would crash with the AuthenticationError because it was not rescued.
=end

class AuthenticationError < StandardError; end

# A mock search engine
# that returns a random number instead of an actual count.
class SearchEngine
  def self.count(query, api_key)
    unless valid?(api_key)
      raise AuthenticationError, 'API key is not valid.'
    end

    rand(200_000)
  end

  private

  def self.valid?(key)
    key == 'LS1A'
  end
end

module DoesItRock
  API_KEY = 'LS1B'

  class NoScore; end

  class Score
    def self.for_term(term)
      positive = SearchEngine.count(%{"#{term} rocks"}, API_KEY).to_f
      negative = SearchEngine.count(%{"#{term} is not fun"}, API_KEY).to_f

      positive / (positive + negative)
    rescue ZeroDivisionError
      NoScore.new
    end
  end

  def self.find_out(term)
    score = Score.for_term(term)

    case score
    when NoScore # NoScore === score; i.e., score is_a? NoScore
      "No idea about #{term}..."
    when 0...0.5
      "#{term} is not fun."
    when 0.5
      "#{term} seems to be ok..."
    else
      "#{term} rocks!"
    end
  rescue StandardError => e
    e.message
  end
end

# Example (your output may differ)

puts DoesItRock.find_out('Sushi')       # Sushi seems to be ok...
puts DoesItRock.find_out('Rain')        # Rain is not fun.
puts DoesItRock.find_out('Bug hunting') # Bug hunting rocks!