module Notifier
  require 'yaml'

  def load_messages
    @messages = YAML.load_file('number_guesser_messages.yml')
  end

  def prompt(action, data = nil)
    puts
    if data
      print (format(@messages[action], data)).to_s
    else
      print (@messages[action]).to_s
    end
  end

  def clear_screen
    system('clear')
  end
end

class GuessingGame
  include Notifier

  def initialize(minimum_target, maximum_target)
    @min_target = minimum_target
    @max_target = maximum_target
    @target = TargetNumber.new(@min_target, @max_target)

    @guessed = nil
    @remaining_guesses = nil
    @guess = nil

    load_messages
  end

  def play
    loop do
      setup_game

      while remaining_guesses?
        display_remaining_guesses
        player_guess

        break if guessed?
      end

      display_game_result

      break unless play_again?
    end
  end

  private

  def setup_game
    @remaining_guesses = calculate_maximum_guesses
    @guessed = false

    @target.set_target

    clear_screen
  end

  def calculate_maximum_guesses
    Math.log2(@max_target - @min_target + 1).to_i + 1
  end

  def remaining_guesses?
    @remaining_guesses > 0
  end

  def display_remaining_guesses
    prompt(:remaining, { rem: @remaining_guesses })
  end

  def player_guess
    loop do
      prompt(:enter, { min: @min_target, max: @max_target } )

      @guess = gets.chomp.to_i
      break if @guess.between?(@min_target, @max_target)
      prompt(:invalid_guess)
    end

    check_guess
    decrement_remaining_guesses
  end

  def check_guess
    @result = @target.compare_guess(@guess)

    if @result == :equal
      @guessed = true
    else
      prompt(:your_guess, { result: @result })
    end
  end

  def guessed?
    @guessed
  end

  def decrement_remaining_guesses
    @remaining_guesses -= 1
  end

  def display_game_result
    if guessed?
      prompt(:you_won)
    else
      prompt(:you_lost)
    end
  end

  def play_again?
    response = nil

    loop do
      prompt(:play_again)
      response = gets.chomp.downcase
      break if %w(y n).include?(response)
      prompt(:invalid_response)
    end

    response == 'y'
  end
end

class TargetNumber
  def initialize(min, max)
    @min = min
    @max = max
    @target = nil
  end

  def set_target
    @target = rand(@min..@max)
  end

  def compare_guess(guess)
    if @target == guess
      :equal
    elsif @target < guess
      'too high'
    else
      'too low'
    end
  end
end

game = GuessingGame.new(1000, 2000)
game.play