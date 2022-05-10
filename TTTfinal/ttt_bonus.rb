=begin
TTT with bonus features:

1. Improved join when listing open spaces (though my plan will be to put the
space number into each unmarked block).

2. Keep score; play to 5 games.

3. Computer defense: block winning move

4. Computer offense: make winning move

5. Order of computer strategy: make winning move, block winning move, select
#5, pick at random

6. Allow player to pick any marker

7. Set names for player and computer

8. minimax algorithm

9. bigger board size (up to 9x9)

10. more than 2 players (optional): make it dependent on board size? 2
players seems like the maximum on a 3x3, maybe go up to 3 players on a 4x4
(maybe max number of players = grid_size - 1). Online research indicates that
 implementing minimax (for the computer moves) might be possible for more
than 2 players, but doing so would be beyond my scope; in any case, in the
procedural tictactoe project, minimax could not be efficiently implemented
beyond a 3x3 grid (though there might be a way to implement it only up to a
certain number of moves ahead, or only when the board has a certain number of
 spaces left--again, it seems beyond my scope for the purposes of this project).

Deviations from walkthrough:
1. Player class handles player moves
2. Scorekeeper class replaces Board class.
3. Display class handles display of the entire scoreboard (grid, scores,
messages).

game process:
instantiate TTTGame object
  - initialize human player
    - get player name
    - get player selection of marker
  - initialize computer player
    - get user selection of computer (name tied to difficulty level)
    - set computer marker
  - initialize scorekeeper
    - get user selection of first turn
    - get user selection of grid size
    - initialize display with grid size, board, and player names (player hash
 with markers?)

TTTGame.play
- display welcome message
- 5-game loop
  - loop (players.cycle)
    - next player turn
    - break if board full or winner
    - display board
  - display_result
- play_again?
  - reset
  - play again message on scoreboard
- goodbye message

Human.move
- get available spaces from scorekeeper
- send move selection to scorekeeper with mark

Computer.move
- get available spaces from scorekeeper
- select per strategy
  - pick at random
  - offense/defense
  - minimax (3x3 grid only)
- send move selection to scorekeeper with mark

module Notifier
- loads all messages from yml file
- prompt method
-

more than 2 players:

max number of players is grid_size - 1

=end

module Notifier
  require 'yaml'

  def load_messages
    @messages = YAML.load_file('ttt_messages.yml')
  end

  def prompt(action, data=nil)
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

module Displayable
  include Notifier

  EMPTY = ' '
  SQ_WIDTH = 7    # set odd number for centering
  SQ_HEIGHT = 3   # set odd number for centering
  TERMINAL_WIDTH = 80
  SCORE_FIELD_WIDTH = 25
  DIVIDERS = { horiz: "\u2500", vert: "\u2502", intersect: "\u253c" }

  def display_board
    clear_screen
    display_header
    draw
  end

  def display_result
    display_board

    winner = find_winner

    if winner
      prompt(:winner, { wins: @players[winner][:name] })
      @players[winner][:score] += 1
    else
      prompt(:tie)
    end
  end

  def display_final
    display_board
    puts
    puts "#{game_winner} wins the game!"
  end

  def game_winner
    @players.max_by { |_, v| v[:score] }[1][:name]
  end

  def display_header
    center = grid_size + grid_size * SQ_WIDTH
    output = []

    output << "--TicTacToe--".center(center)
    output << ''
    output << "--SCORE--".center(center)

    @players.each do |k, v|
      output << "#{v[:name]} (#{k}): #{v[:score]}".center(center)
    end

    puts output
    puts
  end

  def draw
    puts build_grid
  end

  def blank_line
    ([' ' * SQ_WIDTH] * grid_size).join(DIVIDERS[:vert])
  end

  def horiz_divider
    ([DIVIDERS[:horiz] * SQ_WIDTH] * grid_size).join(DIVIDERS[:intersect])
  end

  def marker_lines
    marks.flatten.map.with_index do |mark, idx|
      if mark == EMPTY && grid_size > 3
        "-#{idx + 1}-".center(SQ_WIDTH)
      else
        "\e[31m" + mark.to_s.center(SQ_WIDTH) + "\e[0m"
      end
    end
  end

  def build_grid
    output = []

    marker_lines.each_slice(grid_size) do |squares|
      (SQ_HEIGHT / 2).times { output << blank_line }
      output << squares.join(DIVIDERS[:vert])
      (SQ_HEIGHT / 2).times { output << blank_line }
      output << horiz_divider
    end

    output.delete_at(-1)

    output
  end
end

class Board
  include Displayable

  attr_accessor :marks, :players
  attr_reader :grid_size

  def initialize(messages)
    @players = {}
    @messages = messages
  end

  def grid_size=(grid_size)
    @grid_size = grid_size
    init_marks
  end

  def max_score
    @players.max_by { |_, v| v[:score] }[1][:score]
  end

  def reset_board
    init_marks
  end

  def reset_score
    @players.each do |_, v|
      v[:score] = 0
    end
  end

  def register_player(name, marker)
    players[marker] = Hash.new
    players[marker][:name] = name
    players[marker][:score] = 0
  end

  def find_winner
    find_all_lines.each do |line|
      players.keys.each do |player|
        if line.all?(player)
          return player
        end
      end
    end

    nil
  end

  def winner_found?
    !!find_winner
  end

  def init_marks
    @marks = Array.new(grid_size) { Array.new(grid_size, EMPTY) }
  end

  def find_all_lines
    flip = marks.transpose
    diag1 = (0...grid_size).map { |i| marks[i][i] }
    diag2 = (0...grid_size).map { |i| marks.reverse[i][i] }

    marks + flip + [diag1] + [diag2]
  end

  def available_spaces
    marks.flatten
         .map.with_index { |m, idx| idx + 1 if m == Board::EMPTY }
         .compact
  end

  def available_spaces_string
    available_spaces.join(', ')
                    .reverse
                    .sub(',', ' or'.reverse)
                    .reverse
  end

  def space_empty?(space)
    available_spaces.include?(space)
  end

  def empty?
    marks.flatten.all?(EMPTY)
  end

  def full?
    marks.flatten.none?(EMPTY)
  end

  def mark_choice(choice, marker)
    choice -= 1
    marks[choice / grid_size][choice % grid_size] = marker
  end

  def center_space
    grid_size**2 / 2 + 1
  end
end

class Player
  attr_accessor :name
  attr_reader :marker

  def initialize(board)
    @board = board
  end

  def marker=(marker)
    @marker = marker
    @board.register_player(name, self.marker)
  end
end

class Human < Player
  include Notifier

  def initialize(board, messages)
    @messages = messages
    super(board)
  end

  def move
    choice = 0

    loop do
      prompt(:select)
      puts @board.available_spaces_string if @board.grid_size == 3
      choice = gets.chomp.to_i
      break if @board.available_spaces.include?(choice)
      prompt(:inv_square)
    end

    @board.mark_choice(choice, marker)
  end
end

module Strategic
  class Strategy
    def move(board, marker)
      @board = board
      @marker = marker
    end

    def random_move
      @board.mark_choice(@board.available_spaces.sample, @marker)
    end

    def center_move
      center = @board.center_space
      if @board.grid_size.odd? && @board.space_empty?(center)
        @board.mark_choice(center, @marker)
        return 1
      end

      nil
    end

    def other_players
      @board.players.keys - [@marker]
    end
  end

  class BasicStrategy < Strategy
    def move(board, marker)
      super

      random_move
    end
  end

  class OffenseDefenseStrategy < Strategy
    def move(board, marker)
      super

      center_move ||
        winning_move ||
        blocking_move ||
        random_move
    end

    def winning_move
      @board.available_spaces.each do |space|
        @board.mark_choice(space, @marker)
        return 1 if @board.find_winner == @marker
        @board.mark_choice(space, Board::EMPTY)
      end

      nil
    end

    def blocking_move
      @board.available_spaces.each do |space|
        other_players.each do |player|
          @board.mark_choice(space, player)

          if @board.find_winner == player
            @board.mark_choice(space, @marker)
            return 1
          else
            @board.mark_choice(space, Board::EMPTY)
          end
        end
      end

      nil
    end
  end

  class MinimaxStrategy < Strategy
    def move(board, marker)
      super

      center_move ||
        best_move
    end

    def best_move
      best_score = -100
      best_choice = 0

      # shuffle randomizes the computer AI selection
      # amongst multiple moves with equally highest value
      @board.available_spaces.shuffle.each do |space|
        @board.mark_choice(space, @marker)

        current_score = minimax(0, false)

        @board.mark_choice(space, Board::EMPTY)

        if current_score > best_score
          best_score = current_score
          best_choice = space
        end
      end

      @board.mark_choice(best_choice, @marker)
    end

    def minimax(depth, computer_turn)
      return 10 - depth if @board.find_winner == @marker

      return -10 + depth if @board.find_winner == other_player

      return 0 if @board.full?

      if computer_turn
        best_path = -100

        @board.available_spaces.each do |space|
          @board.mark_choice(space, @marker)

          best_path = [best_path, minimax(depth + 1, !computer_turn)].max

          @board.mark_choice(space, Board::EMPTY)
        end
      else
        best_path = 100

        @board.available_spaces.each do |space|
          @board.mark_choice(space, other_player)

          best_path = [best_path, minimax(depth + 1, !computer_turn)].min

          @board.mark_choice(space, Board::EMPTY)
        end
      end

      best_path
    end

    def other_player
      other_players[0]
    end
  end
end

class Computer < Player
  include Strategic

  attr_accessor :strategy

  def initialize(board)
    super
  end

  def move
    @strategy.move(@board, marker)
  end
end

class TTTGame
  include Notifier

  WINS_PER_GAME = 5
  GRID_SIZES = (3..9).to_a
  DEFAULT_GRID_SIZE = 3
  COMPUTERS = { 'Gus' => { strategy: Strategic::BasicStrategy,
                           description: 'pretty easy',
                           max_grid_size: GRID_SIZES.max },
                'Andy' => { strategy: Strategic::OffenseDefenseStrategy,
                            description: 'a good player',
                            max_grid_size: GRID_SIZES.max },
                'Carson' => { strategy: Strategic::MinimaxStrategy,
                              description: 'unbeatable',
                              max_grid_size: 3 } }
  DEFAULT_COMPUTER = 'Andy'
  DEFAULT_HUMAN_MARKER = 'X'
  DEFAULT_COMPUTER_MARKER = 'O'

  def initialize
    load_messages

    @board = Board.new(@messages)
    @human = Human.new(@board, @messages)
    @computer = Computer.new(@board)
    @players = [@human, @computer]
  end

  def play
    welcome_message
    choose_name
    user_options

    loop do
      main_game
      @board.display_final

      break unless play_again?
      @board.reset_score
    end

    goodbye_message
  end

  def welcome_message
    clear_screen
    prompt(:welcome, { rounds: WINS_PER_GAME.to_s })
    # puts format(@messages[:welcome], { rounds: WINS_PER_GAME.to_s })
  end

  def goodbye_message
    prompt(:goodbye)
  end

  def play_again?
    answer = nil

    loop do
      prompt(:play_again)
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      prompt(:invalid)
    end

    answer == 'y'
  end

  def user_options
    if customize_game?
      choose_marker
      choose_grid_size
      choose_opponent
      choose_first_turn
    else
      choose_default_options
    end
  end

  def choose_default_options
    @human.marker = DEFAULT_HUMAN_MARKER

    @board.grid_size = DEFAULT_GRID_SIZE

    @computer.name = DEFAULT_COMPUTER
    @computer.strategy = COMPUTERS[DEFAULT_COMPUTER][:strategy].new
    @computer.marker = DEFAULT_COMPUTER_MARKER
  end

  def choose_name
    prompt(:name)

    name = nil
    loop do
      name = gets.chomp
      break if name =~ /[A-Za-z]+/
      prompt(:invalid)
    end

    @human.name = name
  end

  def choose_marker
    prompt(:marker)

    marker = nil
    loop do
      marker = gets.chomp
      break if marker !~ /\s/ && marker.length == 1
      prompt(:invalid)
    end

    @human.marker = marker
  end

  def choose_grid_size
    grid_size = nil
    prompt(:grid,
           { grid_min: GRID_SIZES.first, grid_max: GRID_SIZES.last })

    loop do
      grid_size = gets.chomp.to_i
      break if GRID_SIZES.include?(grid_size)
      prompt(:invalid)
    end

    @board.grid_size = grid_size
  end

  def choose_opponent
    opponent = nil

    prompt(:difficulty)
    display_computers

    loop do
      opponent = gets.chomp.to_i
      break if opponent.between?(1, valid_computers.count)
      prompt(:invalid)
    end

    configure_computer(opponent)
  end

  def valid_computers
    COMPUTERS.select do |_, v|
      @board.grid_size <= v[:max_grid_size]
    end
  end

  def display_computers
    valid_computers.each_with_index do |(k, v), idx|
      if @board.grid_size <= v[:max_grid_size]
        puts "#{idx + 1}: #{k} is #{v[:description]}!"
      end
    end
  end

  def configure_computer(opponent)
    @computer.name = COMPUTERS.keys[opponent - 1]
    @computer.strategy = COMPUTERS[@computer.name][:strategy].new
    @computer.marker = @human.marker.upcase == 'X' ? 'O' : 'X'
  end

  def choose_first_turn
    prompt(:first)
    display_players

    first = nil
    loop do
      first = gets.chomp.to_i
      break if first.between?(1, @players.count + 1)
      prompt(:invalid)
    end

    define_player_order(first)
  end

  private

  def main_game
    until @board.max_score >= WINS_PER_GAME
      @board.display_board

      player_turns

      @board.display_result
      prompt(:enter)
      gets
      @board.reset_board
    end
  end

  def player_turns
    @players.cycle do |player|
      player.move
      break if @board.winner_found? || @board.full?
      @board.display_board if player == @computer
    end
  end

  def customize_game?
    prompt(:options)

    options = nil
    loop do
      options = gets.chomp.downcase
      break if %w(y n).include?(options)
      prompt(:invalid)
    end

    options == 'y'
  end

  def define_player_order(first)
    if first == @players.count + 1
      @players.shuffle!
    elsif first != 1
      @players.unshift(@players.delete_at(first - 1))
    end
  end

  def display_players
    @players.each_with_index do |player, idx|
      puts "#{idx + 1}. #{player.name}"
    end
    puts "#{@players.count + 1}. Select at random"
  end
end

TTTGame.new.play
