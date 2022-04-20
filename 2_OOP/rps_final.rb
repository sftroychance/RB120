=begin
Refactoring notes:

1 - Keeping score. Scoreboard class handles calculating and displaying
scores for each round and the entire game.

2 - Adding more moves. The additional moves have been added to the Move class,
per #3 below

3 - Add a class for each move. The < and > methods remain in the parent class,
and each subclass lists the moves that the given subclass beats
or is beaten by. I don't know if this is considered best practice; my
preference would have been to continue with using the Move class, since that
contained all the rules logic in one place (I had previously moved it to a hash
in Move). The subclasses do not add functionality and their state does
not change.

4- Keep track of the history of moves.  Each Player subclass maintains an array
of all its moves in a game. Since the history is printed as part of the
scoreboard, the Scoreboard class generates the table displaying those moves.
Columns are formatted so as not to go longer than the screen; the column length
is set to 10 but expands if the history list exceeds three columns (which does
not seem to happen in a 10-round game but likely would if WINS_PER_GAME were
increased.)

5 - Computer personalities. When started, the game will select one of five
computer personalities at random. The computer types have been subclassed, which
is useful for coding the individual personalities.
=end

class Scoreboard
  SCOREBOARD_WIDTH = 80

  def initialize(human, computer)
    @human = human
    @computer = computer
    @score = { human => 0, computer => 0 }
  end

  def update
    system('clear')

    self.winner = round_winner

    display_border
    display_score
    display_move_history
    display_moves
    display_winner
    display_border
  end

  def display_final_score
    if score[human] > score[computer]
      puts "#{human.name} WINS THE GAME!!"
    else
      puts "#{computer.name} WINS THE GAME!!"
    end

    puts
  end

  def max_score
    score.values.max
  end

  private

  attr_accessor :score, :winner
  attr_reader :human, :computer

  def round_winner
    if human.move > computer.move
      score[human] += 1
      human
    elsif human.move < computer.move
      score[computer] += 1
      computer
    end
  end

  def display_move_history
    puts "MOVE HISTORY:"
    puts

    history = human.move_list.zip(computer.move_list)

    history.map! { |sub| sub.join(' ') }

    header, separator = history.shift(2)

    puts build_table(history, header, separator)
    puts
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
    puts '-' * SCOREBOARD_WIDTH
    puts
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
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
    str = "GAME SCORE    #{human.name}: #{score[human]}   " \
      "#{computer.name}: #{score[computer]}"

    puts str.center(SCOREBOARD_WIDTH)
    puts
  end
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

  def initialize
    @move_history = []
  end

  def move_list
    pad = [name.size + 4, 10].max

    list = [name.to_s.center(pad), ('-' * pad)]

    move_history.each { |m| list << m.to_s.center(pad) }

    list
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

  attr_accessor :move_history
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

class RPSgame
  WINS_PER_GAME = 10
  COMPUTERS = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number5']

  def initialize
    @human = Human.new
    @computer = random_computer
    @scoreboard = Scoreboard.new(human, computer)
  end

  def play
    display_welcome_message

    loop do
      game_loop

      display_game_winner

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

      display_score
    end
  end

  def random_computer
    random_computer_class = Object.const_get(COMPUTERS.sample)

    random_computer_class.new
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, Spock, Lizard!!"
    puts "The first player to win #{WINS_PER_GAME} rounds wins the game!"
    puts
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Spock, Lizard! Goodbye!"
  end

  def display_score
    scoreboard.update
  end

  def display_game_winner
    scoreboard.display_final_score
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
