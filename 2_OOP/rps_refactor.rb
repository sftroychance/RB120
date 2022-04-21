=begin
Refactoring notes following TA feedback:

1 - Recommended modules to handle the display methods
2 - In Player class, attr_accessor could be more limited, to attr_reader
3 - Split scoreboard class since it handles score calculation and display

- modules Displayable and Greetable created to handle display methods
- class Scorekeeper added to handle all score tracking and calculations
- some display formatting removed from Player (formerly move_list)

=end
module Displayable
  def display_scoreboard
    self.winner = score.round_winner

    display_border
    display_score
    display_move_history
    display_moves
    display_winner
    display_border
  end

  def display_final_score
    puts "#{score.game_winner.name} WINS THE GAME!!"
    puts
  end

  private

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
    puts
  end

  def display_move_history
    puts "MOVE HISTORY:"
    puts

    human_moves = list_format(human)
    computer_moves = list_format(computer)

    history = human_moves.zip(computer_moves)

    history.map! { |sub| sub.join(' ') }

    header, separator = history.shift(2)

    puts build_table(history, header, separator)
    puts
  end

  def list_format(player)
    pad = [player.name.size + 4, 10].max

    list = [player.name.to_s.center(pad), ('-' * pad)]

    player.move_history.each { |m| list << m.to_s.center(pad) }

    list
  end

  def build_table(history, header, separator)
    column_length = [10, (history.size / 3.0).ceil].max

    table = history.each_slice(column_length).to_a

    table.last << [nil] * (column_length - table.last.size)

    table.map(&:flatten)
         .map { |line| [header, separator, *line] }
         .transpose
         .map { |line| line.join(' | ') }
  end

  def display_border
    puts
    puts '-' * Scoreboard::SCOREBOARD_WIDTH
    puts
  end

  def display_winner
    if winner
      puts "#{winner.name} wins this round!"
    else
      puts "This round is a tie!"
    end
  end

  def display_score
    str = "GAME SCORE    #{human.name}: #{score.game_score[human]}   " \
      "#{computer.name}: #{score.game_score[computer]}"

    puts str.center(Scoreboard::SCOREBOARD_WIDTH)
    puts
  end
end

class Scorekeeper
  attr_reader :game_score

  def initialize(human, computer)
    @human = human
    @computer = computer
    @game_score = { human => 0, computer => 0 }
  end

  def max_score
    game_score.values.max
  end

  def round_winner
    if human.move > computer.move
      game_score[human] += 1
      human
    elsif computer.move > human.move
      game_score[computer] += 1
      computer
    end
  end

  def game_winner
    game_score.max_by { |_, v| v }.first
  end

  private

  attr_reader :human, :computer
end

class Scoreboard
  include Displayable

  SCOREBOARD_WIDTH = 80

  def initialize(human, computer)
    @human = human
    @computer = computer
    @score = Scorekeeper.new(human, computer)
  end

  def update
    system('clear')

    display_scoreboard
  end

  def max_score
    score.max_score
  end

  private

  attr_accessor :score, :winner
  attr_reader :human, :computer
end

class Move
  VALID_MOVES = ['rock', 'paper', 'scissors', 'Spock', 'lizard']

  def >(other_move)
    beats.include?(other_move.class.to_s)
  end

  def <(other_move)
    beat_by.include?(other_move.class.to_s)
  end

  def to_s
    self.class.to_s.downcase
  end

  private

  attr_reader :beats, :beat_by
end

class Rock < Move
  def initialize
    @beats = ['Scissors', 'Lizard']
    @beat_by = ['Paper', 'Spock']
  end
end

class Paper < Move
  def initialize
    @beats = ['Rock', 'Spock']
    @beat_by = ['Scissors', 'Lizard']
  end
end

class Scissors < Move
  def initialize
    @beats = ['Paper', 'Lizard']
    @beat_by = ['Rock', 'Spock']
  end
end

class Spock < Move
  def initialize
    @beats = ['Rock', 'Scissors']
    @beat_by = ['Paper', 'Lizard']
  end

  def to_s
    'Spock'
  end
end

class Lizard < Move
  def initialize
    @beats = ['Paper', 'Spock']
    @beat_by = ['Scissors', 'Rock']
  end
end

class Player
  attr_accessor :move, :name
  attr_reader :move_history

  def initialize
    @move_history = []
  end

  def choose
    move_history << move
  end

  private

  def make_move(choice)
    case choice.downcase
    when 'r', 'rock'      then Rock.new
    when 'p', 'paper'     then Paper.new
    when 'sc', 'scissors' then Scissors.new
    when 'sp', 'spock'    then Spock.new
    when 'l', 'lizard'    then Lizard.new
    end
  end
end

class Human < Player
  def initialize
    set_name

    super
  end

  def choose
    choice = nil

    loop do
      puts "Please choose (r)ock, (p)aper, (sc)issors, (Sp)ock, or (l)izard"
      choice = gets.chomp

      self.move = make_move(choice)

      break if move
      puts "Sorry, invalid choice."
    end

    super
  end

  def reset
    move_history.clear
  end

  private

  def set_name
    n = ''

    loop do
      system('clear')

      puts "What is your name?"
      n = gets.chomp

      break unless n.empty?
      puts "Sorry, must enter a value"
    end

    self.name = n
  end
end

class Computer < Player
  def initialize
    set_name

    super
  end

  private

  attr_accessor :move_choice

  def set_name
    puts "Your opponent for this game is #{name}!!"
    puts
  end
end

class R2D2 < Computer
  # Personality: Makes same move the entire game

  def initialize
    super

    @move_choice = Move::VALID_MOVES.sample
  end

  def choose
    self.move = make_move(move_choice)

    super
  end

  private

  def set_name
    @name = 'R2D2'

    super
  end
end

class Hal < Computer
  # Personality: Avoids a particular move the entire game

  def initialize
    super

    @move_choice = Move::VALID_MOVES - [Move::VALID_MOVES.sample]
  end

  def choose
    self.move = make_move(move_choice.sample)

    super
  end

  private

  def set_name
    @name = 'Hal'

    super
  end
end

class Chappie < Computer
  # Personality: Selects moves in alphabetical order by name

  def initialize
    super

    @move_choice = Move::VALID_MOVES.sort_by(&:downcase)
  end

  def choose
    last = move_history.last.to_s

    choice =
      if move_history.empty? || last == move_choice.last
        move_choice[0]
      else
        move_choice[move_choice.index(last) + 1]
      end

    self.move = make_move(choice)

    super
  end

  private

  def set_name
    @name = 'Chappie'

    super
  end
end

class Sonny < Computer
  # Personality: Selects from a weighted sample of moves

  def initialize
    super

    weight_move_choice
  end

  def choose
    self.move = make_move(move_choice.sample)

    super
  end

  private

  def weight_move_choice
    self.move_choice = []

    Move::VALID_MOVES.each do |m|
      move_choice << [m] * rand(1..10)
    end

    move_choice.flatten!
  end

  def set_name
    @name = 'Sonny'

    super
  end
end

class Number5 < Computer
  # Personality: Never selects the same move twice in a row

  def initialize
    self.move_choice = Move::VALID_MOVES

    super
  end

  def choose
    new_move = nil

    loop do
      new_move = move_choice.sample
      break if new_move != move_history.last.to_s
    end

    self.move = make_move(new_move)

    super
  end

  private

  def set_name
    @name = 'Number 5'

    super
  end
end

module Greetable
  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, Spock, Lizard!!"
    puts "The first player to win #{RPSgame::WINS_PER_GAME} rounds wins the game!"
    puts
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Spock, Lizard! Goodbye!"
  end
end

class RPSgame
  WINS_PER_GAME = 10
  COMPUTERS = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number5']

  include Greetable

  def initialize
    @human = Human.new
    @computer = random_computer
    @scoreboard = Scoreboard.new(human, computer)
  end

  def play
    display_welcome_message

    loop do
      game_loop

      scoreboard.display_final_score

      play_again? ? reset_game : break
    end

    display_goodbye_message
  end

  private

  attr_reader :human
  attr_accessor :computer, :scoreboard

  def game_loop
    until scoreboard.max_score == WINS_PER_GAME
      human.choose
      computer.choose

      scoreboard.update
    end
  end

  def random_computer
    random_computer_class = Object.const_get(COMPUTERS.sample)

    random_computer_class.new
  end

  def play_again?
    answer = nil

    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase

      break if ['y', 'n'].include?(answer)
      puts "Sorry, must be y or n."
    end

    answer == 'y'
  end

  def reset_game
    system('clear')

    self.computer = random_computer
    human.reset

    self.scoreboard = Scoreboard.new(human, computer)
  end
end

RPSgame.new.play
