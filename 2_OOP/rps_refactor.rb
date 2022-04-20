=begin
Refactoring notes:

1 - Keeping score. A Scoreboard class could handle calculating the score over a
number of games. We could then incorporate the display of results into this
class (like a real-life scoreboard); the Scoreboard class could calculate the
current winner, display the winner, and display the running total, taking those
responsibilities away from the RPSgame class.

2 - Adding more moves: Explore using a hash in the Move class to establish the
rules; the key is each move name, the values are two arrays - one the moves that
beat this move, the other the moves that are beat by this move. With this
refactoring, will consider switching to using a symbol for the move, rather than
a string.

3 - Add a class for each move. Could attempt a class for each move, and the
class (instead of the hash noted in #2 above) will keep track of what moves beat
self, what moves are beat by self. This might be unnecessarily complex; any
updates to the rules of the program would require changes to multiple classes
(in a hash, the rules logic is all in one place).

4 - Keep track of the history of moves. The history of moves could be maintained
by the Scoreboard class (which would query the history for the score update
after each game), but it might make more sense for each Player object to keep
track of its own moves. The tradeoff would be that the Scoreboard would have to
recalculate the results of all games. Perhaps have the Players keep track of
their own moves and have the Scoreboard keep track of just the winners for each
game. A question here would be: are we displaying a running history of the game
moves after each game, or only at the end of a multi-game match?

5 - Computer personalities.  For this functionality, it would seem to make more
sense to have each computer personality as a separate class inherited from
Computer. The choice of computer would be assigned randomly at the start of the
game. As indicated, the variations could be (a) always picking the same move,
(b) picking from a weighted sample, (c) never picking a particular move, (d)
never picking the same move twice in a row, (e) picking the moves in
alphabetical order by name of move. The random selection of computer player
would make for a more complex game for the human player, who would require time
to figure out the strategy for each individual computer. The 'never' and
'always' settings could be selected at random at runtime (e.g., 'Hal' might
never play scissors in one set of games, but in the next set he might never play
'rock'--the basic personality is the same, but the move profile changes game to
game; alphabetical might be reverse-alphabetical sometimes; the weighting of the
moves could change game to game). With this complicated strategy profile, we
might allow the human player to decide how many games will constitute a full
match in the #1 refactor above; and w/r/t #4 (history of moves), it might then
make more sense to display a running move history (though for larger games the
player would have to scroll in the terminal to see all the results, unless a
columnated display is created.)
=end
class Scoreboard
  SCOREBOARD_SIZE = 80

  attr_accessor :score, :winner
  attr_reader :human, :computer

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
    display_history
    display_moves
    display_winner
    display_border
  end

  def display_history
    puts "MOVE HISTORY:"
    puts

    history = human.move_list.zip(computer.move_list)

    history.map! { |sub| sub.join(' ') }

    header, separator = history.shift(2)

    history = build_table(history, header, separator)

    puts history
    puts
  end

  def build_table(lines, header, separator)
    column_length = [10, lines.size / 3].max

    lines = lines.each_slice(column_length).to_a

    lines.last << [nil] * (column_length - lines.last.size)

    lines.map!(&:flatten)

    lines.each { |line| line.prepend(header, separator) }

    lines.transpose.map { |line| line.join(' | ') }
  end

  def display_border
    puts
    puts '-' * SCOREBOARD_SIZE
    puts
  end

  def round_winner
    if human.move > computer.move
      score[human] += 1
      human
    elsif human.move < computer.move
      score[computer] += 1
      computer
    end
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
    str = "SCORE    #{human.name}: #{score[human]}   " \
      "#{computer.name}: #{score[computer]}"

    puts str.center(SCOREBOARD_SIZE)
    puts
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

  def reset
    score.transform_values! { 0 }
  end
end

class Move
  MOVES = { rock: { beats: [:scissors, :lizard], beat_by: [:paper, :Spock] },
            paper: { beats: [:rock, :Spock], beat_by: [:scissors, :lizard] },
            scissors: { beats: [:paper, :lizard], beat_by: [:rock, :Spock] },
            Spock: { beats: [:rock, :scissors], beat_by: [:paper, :lizard] },
            lizard: { beats: [:paper, :Spock], beat_by: [:scissors, :rock] } }

  VALID_MOVES = MOVES.keys.map(&:to_s)

  attr_reader :value

  def initialize(value)
    @value = value.to_sym
  end

  def >(other_move)
    MOVES[value][:beats].include?(other_move.value)
  end

  def <(other_move)
    MOVES[value][:beat_by].include?(other_move.value)
  end

  def to_s
    value.to_s
  end
end

class Player
  attr_accessor :move, :name, :move_history

  def initialize
    @move_history = []
    set_name
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
end

class Human < Player
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

  def choose
    choice = nil

    loop do
      puts "Please choose rock, paper, scissors, Spock, or lizard"
      choice = gets.chomp
      break if Move::VALID_MOVES.include?(choice)
      puts "Sorry, invalid choice."
    end

    self.move = Move.new(choice)
    super
  end

  def reset
    move_history.clear
  end
end

class Computer < Player
  attr_accessor :move_choice

  def set_name
    puts "Your opponent for this game is #{name}!!"
    puts
  end
end

class R2D2 < Computer
  def initialize
    super

    @move_choice = Move::VALID_MOVES.sample
  end

  def set_name
    @name = 'R2D2'

    super
  end

  def choose
    self.move = Move.new(move_choice)

    super
  end
end

class Hal < Computer
  def initialize
    super

    @move_choice = Move::VALID_MOVES - [Move::VALID_MOVES.sample]
  end

  def set_name
    @name = 'Hal'

    super
  end

  def choose
    self.move = Move.new(move_choice.sample)

    super
  end
end

class Chappie < Computer
  def initialize
    super

    @move_choice = Move::VALID_MOVES.sort_by(&:downcase)
  end

  def set_name
    @name = 'Chappie'

    super
  end

  def choose
    last = move_history.last.to_s

    choice =
      if move_history.empty? || last == move_choice.last
        move_choice[0]
      else
        move_choice[move_choice.index(last) + 1]
      end

    self.move = Move.new(choice)

    super
  end
end

class Sonny < Computer
  def initialize
    super

    weight_move_choice
  end

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

  def choose
    self.move = Move.new(move_choice.sample)

    super
  end
end

class Number5 < Computer
  def initialize
    self.move_choice = Move::VALID_MOVES

    super
  end

  def set_name
    @name = 'Number 5'

    super
  end

  def choose
    new_move = nil

    loop do
      new_move = move_choice.sample
      break if new_move != move_history.last.to_s
    end

    self.move = Move.new(new_move)

    super
  end
end

# Game orchestration engine
class RPSgame
  WINS_FOR_THE_GAME = 10
  COMPUTERS = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number5']

  attr_reader :human
  attr_accessor :computer, :scoreboard

  def initialize
    @human = Human.new
    @computer = random_computer
    @scoreboard = Scoreboard.new(human, computer)
  end

  def random_computer
    random_class = Object.const_get(COMPUTERS.sample)

    random_class.new
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, Spock, Lizard!!"
    puts "The first player to win #{WINS_FOR_THE_GAME} rounds wins the game!"
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

  def play
    display_welcome_message

    loop do
      until scoreboard.max_score == WINS_FOR_THE_GAME
        human.choose
        computer.choose
        display_score
      end

      display_game_winner

      play_again? ? reset_game : break
    end

    display_goodbye_message
  end
end

RPSgame.new.play
