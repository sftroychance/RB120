module TwentyOne
  module Displayable
    CARD_WIDTH = 5

    HORIZ_LINE = "\u2500"
    VERT_LINE = "\u2502"
    BORDERS = { top: "\u256D" + CARD_WIDTH * HORIZ_LINE + "\u256E",
                bottom: "\u2570" + CARD_WIDTH * HORIZ_LINE + "\u256F" }

    SUIT_CHARS = { hearts: "\e[31m\u2665\e[0m",
                   diamonds: "\e[31m\u2666\e[0m",
                   spades: "\u2660",
                   clubs: "\u2663" }
    L_HEADER = 20
    R_HEADER = 40

    def welcome_message
      clear_screen
      prompt(:welcome)
    end

    def goodbye_message
      prompt(:goodbye)
      puts
    end

    def display_table
      clear_screen
      display_header
      display_hands
    end

    private

    def display_header
      puts ('*' * L_HEADER) + "SCORE".center(R_HEADER)
      puts "Twenty-One".center(L_HEADER) +
           "Dealer: #{@game_score[:Dealer]}".center(R_HEADER)
      puts ('*' * L_HEADER) + "Player: #{@game_score[:Player]}".center(R_HEADER)
      puts
    end

    def display_hands
      puts "Dealer:"
      display_cards(@dealer)
      puts
      puts "Player:"
      display_cards(@player)
    end

    def display_cards(player) # move to Hand#display_hand
      cards = []
      player.hand.cards.each_with_index do |card, idx|
        cards << if player.class == Dealer && @hide_dealer && idx == 1
                   mystery_card(format_card(card))
                 else
                   format_card(card)
                 end
      end

      format_bust_card(cards) if player.hand.busted?

      puts rack_cards(cards)
    end

    def format_card(card) # move to Card#format_card
      face_pad = CARD_WIDTH - card[:face].length
      suit_pad = CARD_WIDTH / 2
      face = color_face(card)

      blank_line = ' ' * CARD_WIDTH

      top_face_line = face + ' ' * face_pad
      bottom_face_line = ' ' * face_pad + face

      suit_line = ' ' * suit_pad + SUIT_CHARS[card[:suit]] + ' ' * suit_pad

      [top_face_line, blank_line, suit_line, blank_line, bottom_face_line]
    end

    def add_borders(cards)
      cards.each do |card|
        card.map! do |line|
          VERT_LINE + line + VERT_LINE
        end

        card.unshift(BORDERS[:top])
        card.push(BORDERS[:bottom])
      end
    end

    def mystery_card(card) #move to Card#mystery_card
      card[0] = '??   '
      card[2] = '  ?  '
      card[4] = '   ??'

      card
    end

    def format_bust_card(cards) # move to Card#format_bust_card
      cards.last[1] = HORIZ_LINE * 5
      cards.last[2] = 'BUST!'
      cards.last[3] = HORIZ_LINE * 5
    end

    def rack_cards(cards) # move to Hand#rack_cards
      add_borders(cards)

      cards.transpose.map { |lines| lines.join(' ') }
    end

    def color_face(card) # move to Card#color_face
      if [:hearts, :diamonds].include?(card[:suit])
        "\e[31m" + card[:face] + "\e[0m"
      else
        card[:face]
      end
    end

    def display_hand_result
      winner = hand_winner

      update_score(winner) if winner

      display_table

      if winner
        prompt(:winner, { wins: winner })
      else
        prompt(:nobody_wins)
      end

      puts
    end

    def display_game_result
      display_table

      if game_winner == :Nobody
        prompt(:game_tie)
      else
        prompt(:game_winner, { winner: game_winner })
      end
    end

    def hand_winner
      if @player.hand.busted?
        :Dealer
      elsif @dealer.hand.busted?
        :Player
      elsif @dealer.hand.score > @player.hand.score
        :Dealer
      elsif @player.hand.score > @dealer.hand.score
        :Player
      end
    end

    def update_score(winner)
      @game_score[winner] += 1
    end

    def game_winner
      if @game_score.values.uniq.size == 1
        :Nobody
      else
        @game_score.max_by { |_, v| v }.first.to_s
      end
    end
  end

  module Notifier
    require 'yaml'

    def load_messages
      @messages = YAML.load_file('twenty_one_messages.yml')
    end

    def prompt(action, data = nil)
      puts
      if data
        puts "=> #{format(@messages[action], data)}"
      else
        puts "=> #{@messages[action]}"
      end
    end

    def clear_screen
      system('clear')
    end
  end

  class Deck
    SUITS = [:spades, :clubs, :hearts, :diamonds]
    FACES = ('2'..'10').to_a + %w(J Q K A)

    def initialize
      @card = Struct.new(:face, :suit, :value)
      @deck = []
    end

    def add_deck
      new_deck = []

      FACES.each do |face|
        SUITS.each do |suit|
          value = card_value(face)
          new_deck << @card.new(face, suit, value)
        end
      end

      @deck += new_deck.shuffle
    end

    def deal_hand
      add_deck if @deck.size < 52

      @deck.shift(2)
    end

    def deal_card
      @deck.shift
    end

    private

    def card_value(face)
      case face
      when ('2'..'9') then face.to_i
      when 'A' then 11
      else 10
      end
    end
  end

  class Player
    include Notifier

    attr_accessor :hand

    def initialize
      @hand = Hand.new
      @messages = load_messages
    end

    def hit?
      choice = nil

      loop do
        prompt(:hit_or_stay)
        choice = gets.chomp.downcase
        break if %w(h s).include?(choice)
        prompt(:invalid)
      end

      choice == 'h'
    end
  end

  class Dealer < Player
    STAY_SCORE = 17

    def initialize
      @hand = Hand.new
    end

    def hit?
      @hand.score < STAY_SCORE
    end
  end

  class Hand
    MAX_POINTS = 21

    attr_reader :cards

    def initialize
      @cards = []
    end

    def score
      score = @cards.inject(0) { |sum, card| sum + card[:value] }

      score > MAX_POINTS ? reduce_aces(score) : score
    end

    def busted?
      score > MAX_POINTS
    end

    def add(cards)
      @cards += cards
    end

    def reset
      @cards = []
    end

    private

    def reduce_aces(score)
      aces = @cards.select { |card| card[:face] == 'A' }
                   .count

      until score <= MAX_POINTS || aces == 0
        score -= 10
        aces -= 1
      end

      score
    end
  end

  class Card
    attr_accessor :face, :suit, :value

    def initialize(face, suit, value)
      @face = face
      @suit = suit
      @value = value
    end
  end

  class TwentyOneGame
    include Displayable
    include Notifier

    def initialize
      @messages = load_messages
      @deck = Deck.new
      @player = Player.new
      @dealer = Dealer.new

      @game_score = { Player: 0, Dealer: 0 }
      @hide_dealer = true
    end

    def play
      welcome_message

      loop do
        deal_hands
        player_turns
        display_hand_result

        break unless play_again?
        reset_hands
      end

      display_game_result
      goodbye_message
    end

    private

    def deal_hands
      @player.hand.add(@deck.deal_hand)
      @dealer.hand.add(@deck.deal_hand)
    end

    def player_turns
      @hide_dealer = true

      take_turn(@player)

      @hide_dealer = false

      if @player.hand.busted?
        display_table
        return
      end

      take_turn(@dealer)
    end

    def take_turn(player)
      loop do
        display_table

        break unless !player.hand.busted? && player.hit?

        player.hand.add([@deck.deal_card])

        sleep(1) if player.class == Dealer
      end
    end

    def play_again?
      choice = nil

      loop do
        prompt(:play_again)
        choice = gets.chomp.downcase
        break if %w(y n).include?(choice)
        prompt(:invalid)
      end

      choice == 'y'
    end

    def reset_hands
      @player.hand.reset
      @dealer.hand.reset
    end
  end
end

TwentyOne::TwentyOneGame.new.play
