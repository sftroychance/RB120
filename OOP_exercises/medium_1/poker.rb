=begin Further exploration questions: How would you modify this class if you
wanted the individual classification methods (royal_flush?, straight?,
three_of_a_kind?, etc) to be public class methods that work with an Array of 5
cards, e.g.,

=> Done. Wrote class method versions for the classification methods (except
high_card, which didn't seem to make sense in the context). Altered the logic
of the instance methods (which were written to find the highest-ranked hand) to
allow, for instance, a 'four of a kind' to also respond true to test for 'three
of a kind' or 'two pair', since strictly those tests are true (just not the
highest hand rank possible from the hand.)  This is something I would otherwise
clarify before making this change.

How would you modify our original solution to choose the best hand between two
poker hands?

Implemented. Created an array of the hand classifications sorted by rank and
wrote PokerHand#<=> to compare the indices in that array.

How would you modify our original solution to choose the best 5-card hand from
a 7-card poker hand?

Implemented.
- Separate class SevenCardHand; PokerHand is defined as a 5-card hand, and I
  don't want to create problems by introducing a 7-card hand (e.g., the ability
to call 5-card methods on a 7-card hand)
- method SevenCardHand#best_hand to:
- create an array of 5-card combinations (each_combination) from the seven
  cards given
  - create a new PokerHand object for each combination and add each object to a
    hand_candidates array
  - get highest-rated hand in the candidates array by rank of the hand--having
    defined the <=> method for PokerHand as noted above: candidates.max
  - print the best 5-card hand
=end

class Card
  include Comparable

  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze

  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{rank} of #{suit}"
  end

  def <=>(other)
    RANKS.index(rank) <=> RANKS.index(other.rank)
  end
end

class Deck
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze
  RANKS = Card::RANKS

  attr_reader :deck

  def initialize
    @deck = populate_deck
  end

  def draw
    populate_deck if @deck.empty?
    @deck.shift
  end

  private

  def populate_deck
    new_deck = []
    SUITS.each do |suit|
      RANKS.each do |rank|
        new_deck << Card.new(rank, suit)
      end
    end

    new_deck.shuffle
  end
end

class PokerHand
  include Comparable

  HAND_TYPES = ['High card', 'Pair', 'Two pair', 'Three of a kind',
                'Straight', 'Flush', 'Full house', 'Four of a kind',
                'Straight flush', 'Royal flush']

  class << self
    def royal_flush?(cards)
      same_suit?(cards) && straight?(cards) &&
        ranks(cards).min_by { |rank| Card::RANKS.index(rank) } == 10
    end

    def straight_flush?(cards)
      straight?(cards) && same_suit?(cards)
    end

    def four_of_a_kind?(cards)
      ranks = self.ranks(cards)

      ranks.uniq
           .each { |rank| return true if ranks.count(rank) == 4 }

      false
    end

    def full_house?(cards)
      ranks(cards).tally.values.sort == [2, 3]
    end

    def flush?(cards)
      same_suit?(cards)
    end

    def straight?(cards)
      sequential?(ranks(cards))
    end

    def three_of_a_kind?(cards)
      ranks = self.ranks(cards)

      ranks.uniq
           .each { |rank| return true if ranks.count(rank) >= 3 }

      false
    end

    def two_pair?(cards)
      counts = ranks(cards).tally.values.sort

      counts == [1, 2, 2] || counts == [1, 4]
    end

    def pair?(cards)
      ranks(cards).tally.values.any? { |v| v >= 2 }
    end

    private

    def sequential?(ranks)
      values = ranks.map { |rank| Card::RANKS.index(rank) }.sort
      values.each_cons(2) { |a, b| return false unless b - a == 1 }

      true
    end

    def ranks(cards)
      cards.map(&:rank)
    end

    def same_suit?(cards)
      suits = cards.map(&:suit)
      suits.uniq.size == 1
    end
  end

  def initialize(cards)
    cards = cards.dup
    @cards = []

    5.times { @cards << cards.draw }
  end

  def print
    @cards.each { |card| puts "#{card.rank} of #{card.suit}" }
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  def <=>(other)
    HAND_TYPES.index(evaluate) <=> HAND_TYPES.index(other.evaluate)
  end

  private

  def ranks
    @cards.sort.map(&:rank)
  end

  def suits
    @cards.map(&:suit).sort
  end

  def sequential?
    values = ranks.map { |rank| Card::RANKS.index(rank) }
    values.each_cons(2) { |a, b| return false unless b - a == 1 }

    true
  end

  def same_suit?
    suits.uniq.size == 1
  end

  def royal_flush?
    sequential? && ranks[0] == 10 && same_suit?
  end

  def straight_flush?
    sequential? && same_suit?
  end

  def four_of_a_kind?
    ranks.uniq.each { |rank| return true if ranks.count(rank) == 4 }

    false
  end

  def full_house?
    ranks.tally.values.sort == [2, 3]
  end

  def flush?
    same_suit?
  end

  def straight?
    sequential?
  end

  def three_of_a_kind?
    ranks.uniq.each { |rank| return true if ranks.count(rank) >= 3 }

    false
  end

  def two_pair?
    counts = ranks.tally.values.sort

    counts == [1, 2, 2] || counts == [1, 4]
  end

  def pair?
    ranks.tally.values.any? { |v| v >= 2 }
  end
end

class SevenCardHand
  def initialize(cards)
    @cards = cards
  end

  def best_poker_hand
    candidates = @cards.combination(5).to_a
    candidates.map! { |cards| PokerHand.new(cards) }

    best_hand = candidates.max
    puts "Best hand: #{best_hand.evaluate}"
    best_hand.print
  end
end

hand = PokerHand.new(Deck.new)
hand.print
puts hand.evaluate

# Danger danger danger: monkey
# patching for testing purposes.
class Array
  alias_method :draw, :pop
end

# Test that we can identify each PokerHand type.

my_hand1 = [
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
]

hand = PokerHand.new(my_hand1)
puts hand.evaluate == 'Royal flush'
puts my_hand1
puts PokerHand.royal_flush?(my_hand1)

my_hand2 = [
  Card.new(8,       'Clubs'),
  Card.new(9,       'Clubs'),
  Card.new('Queen', 'Clubs'),
  Card.new(10,      'Clubs'),
  Card.new('Jack',  'Clubs')
]
hand = PokerHand.new(my_hand2)
puts hand.evaluate == 'Straight flush'
puts PokerHand.straight_flush?(my_hand2)

my_hand3 = [
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
]

hand = PokerHand.new(my_hand3)
puts hand.evaluate == 'Four of a kind'
puts PokerHand.four_of_a_kind?(my_hand3)
puts PokerHand.three_of_a_kind?(my_hand3)
puts PokerHand.pair?(my_hand3)

my_hand4 = [
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Hearts')
]
hand = PokerHand.new(my_hand4)
puts hand.evaluate == 'Full house'
puts PokerHand.full_house?(my_hand4)

my_hand5 = [
  Card.new(10, 'Hearts'),
  Card.new('Ace', 'Hearts'),
  Card.new(2, 'Hearts'),
  Card.new('King', 'Hearts'),
  Card.new(3, 'Hearts')
]

hand = PokerHand.new(my_hand5)
puts hand.evaluate == 'Flush'
puts PokerHand.flush?(my_hand5)

my_hand6 = [
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
]

hand = PokerHand.new(my_hand6)
puts hand.evaluate == 'Straight'
puts PokerHand.straight?(my_hand6)

my_hand7 = [
  Card.new('Queen', 'Clubs'),
  Card.new('King',  'Diamonds'),
  Card.new(10,      'Clubs'),
  Card.new('Ace',   'Hearts'),
  Card.new('Jack',  'Clubs')
]

hand = PokerHand.new(my_hand7)
puts hand.evaluate == 'Straight'
puts PokerHand.straight?(my_hand7)

my_hand8 = [
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
]

hand = PokerHand.new(my_hand8)
puts hand.evaluate == 'Three of a kind'
puts PokerHand.three_of_a_kind?(my_hand8)
puts PokerHand.pair?(my_hand8)

my_hand9 = [
  Card.new(9, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(8, 'Spades'),
  Card.new(5, 'Hearts')
]

hand = PokerHand.new(my_hand9)
puts hand.evaluate == 'Two pair'
puts PokerHand.two_pair?(my_hand9)
puts PokerHand.pair?(my_hand9)

my_hand10 = [
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
]

hand = PokerHand.new(my_hand10)
puts hand.evaluate == 'Pair'
puts PokerHand.pair?(my_hand10)

hand = PokerHand.new([
                       Card.new(2,      'Hearts'),
                       Card.new('King', 'Clubs'),
                       Card.new(5,      'Diamonds'),
                       Card.new(9,      'Spades'),
                       Card.new(3,      'Diamonds')
                     ])
puts hand.evaluate == 'High card'

puts PokerHand.new(my_hand1) > PokerHand.new(my_hand2)
puts PokerHand.new(my_hand2) > PokerHand.new(my_hand1) # => false
puts PokerHand.new(my_hand3) > PokerHand.new(my_hand9)

seven_hand = my_hand8 + [Card.new(5, 'Clubs'),
                         Card.new(9, 'Diamonds')]

hand = SevenCardHand.new(seven_hand)
hand.best_poker_hand
