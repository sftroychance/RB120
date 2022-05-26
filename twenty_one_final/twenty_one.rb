module TwentyOne
  module Displayable
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
      header = []
      header << ('*' * L_HEADER) + "SCORE".center(R_HEADER)
      header << "Twenty-One".center(L_HEADER) +
                "#{@dealer.name}: #{@game_score[:Dealer]}".center(R_HEADER)
      header << ('*' * L_HEADER) +
                "#{@player.name}: #{@game_score[:Player]}".center(R_HEADER)

      puts header
    end

    def display_hands
      puts
      puts "#{@dealer.name}:"
      @dealer.show_hand

      puts
      puts "#{@player.name}:"
      @player.show_hand
    end

    def display_hand_result
      winner = hand_winner
      update_game_score(winner) if winner

      display_table

      name = winner_name(winner)

      winner ? prompt(:winner, { wins: name }) : prompt(:nobody_wins)

      puts
    end

    def winner_name(winner)
      case winner
      when :Dealer then @dealer.name
      when :Player then @player.name
      end
    end

    def display_game_result
      display_table

      winner = game_winner

      if winner == :Nobody
        prompt(:game_tie)
      else
        prompt(:game_winner, { winner: winner_name(winner) })
      end
    end

    def hand_winner
      if @player.busted?
        :Dealer
      elsif @dealer.busted?
        :Player
      elsif @dealer.score > @player.score
        :Dealer
      elsif @player.score > @dealer.score
        :Player
      end
    end

    def update_game_score(winner)
      @game_score[winner] += 1
    end

    def game_winner
      if @game_score.values.uniq.size == 1
        :Nobody
      else
        @game_score.max_by { |_, v| v }.first
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
      @deck = []
    end

    def add_deck
      new_deck = []

      FACES.each do |face|
        SUITS.each do |suit|
          value = card_value(face)
          new_deck << Card.new(face, suit, value)
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

  class Card
    CARD_WIDTH = 7 # set to odd value for card centering

    SUIT_CHARS = { hearts: "\e[31m\u2665\e[0m",
                   diamonds: "\e[31m\u2666\e[0m",
                   spades: "\u2660",
                   clubs: "\u2663" }

    attr_accessor :face, :suit, :value

    def initialize(face, suit, value)
      @face = face
      @suit = suit
      @value = value
    end

    def format_card
      face_pad = CARD_WIDTH - face.length
      suit_pad = CARD_WIDTH / 2
      display_face = color_face

      blank_line = ' ' * CARD_WIDTH

      top_face_line = display_face + ' ' * face_pad
      bottom_face_line = ' ' * face_pad + display_face

      suit_line = ' ' * suit_pad + SUIT_CHARS[suit] + ' ' * suit_pad

      [top_face_line, blank_line, suit_line, blank_line, bottom_face_line]
    end

    def mystery_card
      new_card = format_card
      new_card[0] = '??'.ljust(CARD_WIDTH)
      new_card[2] = '?'.center(CARD_WIDTH)
      new_card[4] = '??'.rjust(CARD_WIDTH)

      new_card
    end

    def color_face
      if [:hearts, :diamonds].include?(suit)
        "\e[31m" + face + "\e[0m"
      else
        face
      end
    end
  end

  class Hand
    CARD_WIDTH = Card::CARD_WIDTH

    HORIZ_LINE = "\u2500"
    VERT_LINE = "\u2502"
    BORDERS = { top: "\u256D" + HORIZ_LINE * CARD_WIDTH + "\u256E",
                bottom: "\u2570" + HORIZ_LINE * CARD_WIDTH + "\u256F" }

    MAX_POINTS = 21

    def initialize
      @cards = []
    end

    def score
      score = @cards.inject(0) { |sum, card| sum + card.value }

      ace_count = @cards.select { |card| card.face == 'A' }
                        .size

      ace_count.times { score -= 10 if score > MAX_POINTS }

      score
    end

    def busted?
      score > MAX_POINTS
    end

    def add(new_cards)
      @cards += new_cards
    end

    def reset
      @cards = []
    end

    def display_cards(hide_card = false)
      @display_cards = []
      @cards.each_with_index do |card, idx|
        @display_cards << if hide_card && idx == 1
                            card.mystery_card
                          else
                            card.format_card
                          end
      end

      format_bust_card if busted?

      puts card_spread
    end

    private

    def format_bust_card
      @display_cards.last[1] = HORIZ_LINE * CARD_WIDTH
      @display_cards.last[2] = 'BUST!'.center(CARD_WIDTH)
      @display_cards.last[3] = HORIZ_LINE * CARD_WIDTH
    end

    def card_spread
      add_borders

      @display_cards.transpose.map { |lines| lines.join(' ') }
    end

    def add_borders
      @display_cards.each do |card|
        card.map! do |line|
          VERT_LINE + line + VERT_LINE
        end

        card.unshift(BORDERS[:top])
        card.push(BORDERS[:bottom])
      end
    end
  end

  class Participant
    attr_accessor :hand, :name

    def initialize
      @hand = Hand.new
    end

    def busted?
      hand.busted?
    end

    def score
      hand.score
    end

    def add(cards)
      hand.add(cards)
    end

    def reset
      hand.reset
    end
  end

  class Player < Participant
    include Notifier

    def initialize
      load_messages
      super
    end

    def set_name
      name = nil

      loop do
        prompt(:name)
        name = gets.chomp
        break if name =~ /[A-Za-z]+/
        prompt(:invalid)
      end

      prompt(:howdy, { name: name })

      @name = name
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

    def show_hand
      hand.display_cards
    end
  end

  class Dealer < Participant
    COMPUTERS = %w(Hal Primus Tobor Siri)
    STAY_SCORE = 17

    attr_accessor :hide_hand

    def initialize
      super
    end

    def set_name
      @name = COMPUTERS.sample
    end

    def hit?
      @hand.score < STAY_SCORE
    end

    def show_hand
      hand.display_cards(@hide_hand)
    end
  end

  class TwentyOneGame
    include Displayable
    include Notifier

    def initialize
      load_messages

      @deck = Deck.new
      @player = Player.new
      @dealer = Dealer.new

      @game_score = { Player: 0, Dealer: 0 }
    end

    def play
      welcome

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

    def welcome
      welcome_message

      @player.set_name
      @dealer.set_name

      prompt(:dealer_name, { dealer: @dealer.name })
      puts
      prompt(:enter)
      gets
    end

    def deal_hands
      @player.add(@deck.deal_hand)
      @dealer.add(@deck.deal_hand)
    end

    def player_turns
      @dealer.hide_hand = true

      take_turn(@player)

      @dealer.hide_hand = false

      if @player.busted?
        display_table
        return
      end

      take_turn(@dealer)
    end

    def take_turn(player)
      loop do
        display_table

        break unless !player.busted? && player.hit?

        player.add([@deck.deal_card])

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
      @player.reset
      @dealer.reset
    end
  end
end

TwentyOne::TwentyOneGame.new.play
