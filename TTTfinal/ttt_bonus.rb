module TTT
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
      draw_grid
    end

    def display_result
      winner = find_winner

      if winner
        @players[winner][:score] += 1
        display_board
        prompt(:winner, { wins: @players[winner][:name] })
      else
        display_board
        prompt(:tie)
      end
    end

    def display_final
      display_board
      puts
      prompt(:game_winner, { name: game_winner })
    end

    private

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

    def blank_line
      ([' ' * SQ_WIDTH] * grid_size).join(DIVIDERS[:vert])
    end

    def horiz_divider
      ([DIVIDERS[:horiz] * SQ_WIDTH] * grid_size).join(DIVIDERS[:intersect])
    end

    def marker_lines
      @marks.flatten.map.with_index do |mark, idx|
        if mark == EMPTY && grid_size > 3
          "-#{idx + 1}-".center(SQ_WIDTH)
        else
          "\e[31m" + mark.to_s.center(SQ_WIDTH) + "\e[0m"
        end
      end
    end

    def draw_grid
      puts build_grid
    end

    def build_grid
      output = []

      marker_lines.each_slice(grid_size) do |squares|
        (SQ_HEIGHT / 2).times { output << blank_line }
        output << squares.join(DIVIDERS[:vert])
        (SQ_HEIGHT / 2).times { output << blank_line }
        output << horiz_divider
      end

      output.pop

      output
    end
  end

  class Board
    include Displayable

    attr_reader :grid_size, :players

    def initialize(grid_size)
      load_messages
      @grid_size = grid_size
      @players = {}
      init_marks
    end

    def register_players(all_players)
      all_players.each do |player|
        @players[player.marker] = Hash.new
        @players[player.marker][:name] = player.name
        @players[player.marker][:score] = 0
      end
    end

    def winner_found?
      !!find_winner
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

    def space_empty?(space)
      available_spaces.include?(space)
    end

    def full?
      @marks.flatten.none?(EMPTY)
    end

    def max_score
      players.max_by { |_, v| v[:score] }[1][:score]
    end

    def mark_choice(choice, marker)
      choice -= 1
      @marks[choice / grid_size][choice % grid_size] = marker
    end

    def reset_board
      init_marks
    end

    def reset_score
      players.each do |_, v|
        v[:score] = 0
      end
    end

    def available_spaces
      @marks.flatten
            .map.with_index { |m, idx| idx + 1 if m == Board::EMPTY }
            .compact
    end

    def available_spaces_string
      available_spaces.join(', ')
                      .reverse
                      .sub(',', ' or'.reverse)
                      .reverse
    end

    def center_space
      grid_size**2 / 2 + 1
    end

    private

    def init_marks
      @marks = Array.new(grid_size) { Array.new(grid_size, EMPTY) }
    end

    def find_all_lines
      flip = @marks.transpose
      diag1 = (0...grid_size).map { |i| @marks[i][i] }
      diag2 = (0...grid_size).map { |i| @marks.reverse[i][i] }

      @marks + flip + [diag1] + [diag2]
    end
  end

  class Player
    attr_reader :name, :marker

    def initialize(name, marker, board)
      @name = name
      @marker = marker
      @board = board
    end

    private

    attr_reader :board
  end

  class Human < Player
    include Notifier

    def initialize(name, marker, board)
      super(name, marker, board)
      load_messages
    end

    def move
      choice = nil

      loop do
        prompt(:select, { name: name })
        puts board.available_spaces_string if board.grid_size == 3
        choice = gets.chomp.to_i
        break if board.available_spaces.include?(choice)
        prompt(:inv_square)
      end

      board.mark_choice(choice, @marker)
    end
  end

  module Strategic
    def set_attributes(board, marker)
      @board = board
      @marker = marker
    end

    private

    attr_reader :board, :marker

    def random_move
      board.mark_choice(board.available_spaces.sample, marker)
    end

    def center_move
      center = board.center_space
      if board.grid_size.odd? && board.space_empty?(center)
        board.mark_choice(center, marker)
        return 1
      end

      nil
    end

    def winning_move
      board.available_spaces.each do |space|
        board.mark_choice(space, marker)
        return 1 if board.find_winner == marker
        board.mark_choice(space, Board::EMPTY)
      end

      nil
    end

    def blocking_move
      board.available_spaces.each do |space|
        other_players.each do |player|
          return test_blocks(player, space)
        end
      end

      nil
    end

    def test_blocks(player, space)
      board.mark_choice(space, player)

      if board.find_winner == player
        board.mark_choice(space, marker)
        1
      else
        board.mark_choice(space, Board::EMPTY)
        nil
      end
    end

    def offense_defense
      center_move ||
        winning_move ||
        blocking_move ||
        random_move
    end

    def other_players
      board.players.keys - [marker]
    end
  end

  class BasicStrategy
    include Strategic

    def initialize(board, marker)
      set_attributes(board, marker)
    end

    def move
      random_move
    end
  end

  class OffenseDefenseStrategy
    include Strategic

    def initialize(board, marker)
      set_attributes(board, marker)
    end

    def move
      offense_defense
    end
  end

  class MinimaxStrategy
    include Strategic

    MAX_EMPTY_SPACES = 9

    def initialize(board, marker)
      set_attributes(board, marker)
    end

    def move
      if board.grid_size > 3 && board.available_spaces.size > MAX_EMPTY_SPACES
        offense_defense
      else
        center_move ||
          best_move
      end
    end

    private

    def best_move
      best_score = -100
      best_choice = 0

      board.available_spaces.shuffle.each do |space|
        current_score = test_space(space)

        if current_score > best_score
          best_score = current_score
          best_choice = space
        end
      end

      board.mark_choice(best_choice, marker)
    end

    def test_space(space)
      board.mark_choice(space, marker)

      current_score = minimax(0, false)

      board.mark_choice(space, Board::EMPTY)
      current_score
    end

    def minimax(depth, computer_turn)
      return 10 - depth if board.find_winner == marker

      return -10 + depth if board.find_winner == other_player

      return 0 if board.full?

      if computer_turn
        test_computer_move(computer_turn, depth)
      else
        test_opponent_move(computer_turn, depth)
      end
    end

    def test_opponent_move(computer_turn, depth)
      best_path = 100

      board.available_spaces.each do |space|
        board.mark_choice(space, other_player)

        best_path = [best_path, minimax(depth + 1, !computer_turn)].min

        board.mark_choice(space, Board::EMPTY)
      end
      best_path
    end

    def test_computer_move(computer_turn, depth)
      best_path = -100

      board.available_spaces.each do |space|
        board.mark_choice(space, marker)

        best_path = [best_path, minimax(depth + 1, !computer_turn)].max

        board.mark_choice(space, Board::EMPTY)
      end
      best_path
    end

    def other_player
      other_players[0]
    end
  end

  class Computer < Player
    def initialize(name, marker, board, strategy)
      super(name, marker, board)
      @strategy = strategy
    end

    def move
      @strategy.move
      sleep(1)
    end
  end

  class Configuration
    include Notifier

    attr_reader :board, :players

    WINS_PER_GAME = 5
    GRID_SIZES = (3..9).to_a
    DEFAULT_GRID_SIZE = 3
    STRATEGIES = { Easy: BasicStrategy,
                   Challenging: OffenseDefenseStrategy,
                   Impossible?: MinimaxStrategy }
    DEFAULT_COMPUTER_NAME = 'Dallas'
    DEFAULT_HUMAN_MARKER = 'X'
    DEFAULT_COMPUTER_MARKER = 'O'

    def initialize
      load_messages
      @options = {}

      @taken_names = []
      @taken_markers = []
    end

    def configure
      @player_name = choose_name(is_main_player: true)

      customize_game? ? choose_custom_options : choose_default_options

      create_board
      create_main_player
      create_opponents

      choose_first_turn
      board.register_players(@players)
    end

    private

    attr_writer :board, :players
    attr_accessor :options

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

    def choose_default_options
      options[:grid_size] = DEFAULT_GRID_SIZE

      options[:player] = { type: 'human',
                           name: @player_name,
                           marker: DEFAULT_HUMAN_MARKER }

      options[:opponents] = [{ type: 'computer',
                               name: DEFAULT_COMPUTER_NAME,
                               strategy: OffenseDefenseStrategy,
                               marker: DEFAULT_COMPUTER_MARKER }]
    end

    def choose_custom_options
      player_marker = choose_marker(is_main_player: true)
      options[:grid_size] = choose_grid_size

      options[:player] = { name: @player_name, marker: player_marker }

      options[:opponents] = choose_opponents
    end

    def choose_grid_size
      prompt(:grid,
             { grid_min: GRID_SIZES.first, grid_max: GRID_SIZES.last })

      grid_size = nil
      loop do
        grid_size = gets.chomp.to_i
        break if GRID_SIZES.include?(grid_size)
        prompt(:invalid)
      end

      grid_size
    end

    def choose_name(is_main_player: false)
      is_main_player ? prompt(:name) : prompt(:opponent_name)

      name = nil
      loop do
        name = gets.chomp
        break if name =~ /[A-Za-z]+/ && !name_taken?(name)
        prompt(:taken_name) if name_taken?(name)
        prompt(:invalid)
      end

      @taken_names << name

      name
    end

    def name_taken?(name)
      @taken_names.include?(name)
    end

    def choose_marker(is_main_player: false)
      is_main_player ? prompt(:marker) : prompt(:opponent_marker)

      marker = nil
      loop do
        marker = gets.chomp
        break if marker !~ /\s/ && marker.length == 1 && !marker_taken?(marker)
        prompt(:taken_marker) if marker_taken?(marker)
        prompt(:invalid)
      end

      @taken_markers << marker

      marker
    end

    def marker_taken?(marker)
      @taken_markers.include?(marker)
    end

    def choose_opponents
      opponents = []

      num_opponents = choose_num_of_opponents(max_opponents)

      (1..num_opponents).each do |opp_number|
        opponent_prompt(num_opponents, opp_number)

        player_info = opponent_options

        opponents << { type: player_info[:type], name: player_info[:name],
                       marker: player_info[:marker],
                       strategy: player_info[:strategy] }
      end

      opponents
    end

    def choose_num_of_opponents(max)
      return 1 if max == 1

      prompt(:num_opponents, { max: max })

      number = nil
      loop do
        number = gets.chomp.to_i
        break if number.between?(1, max)
        prompt(:invalid)
      end

      number
    end

    def max_opponents
      [1, options[:grid_size] - 3].max
    end

    def opponent_prompt(number_of_opponents, opp_number)
      clear_screen
      if number_of_opponents == 1
        prompt(:single_opponent)
      else
        prompt(:multiple_opponent, { opponent_number: opp_number })
      end
    end

    def opponent_options
      opponent = {}

      opponent[:name] = choose_name
      opponent[:marker] = choose_marker
      opponent[:type] = choose_player_type

      opponent[:strategy] =
        opponent[:type] == 'computer' ? choose_difficulty : nil

      opponent
    end

    def choose_player_type
      prompt(:player_type)

      type = nil
      loop do
        type = gets.chomp.to_i
        break if [1, 2].include?(type)
        prompt(:invalid)
      end

      %w(human computer)[type - 1]
    end

    def choose_difficulty
      prompt(:difficulty)

      STRATEGIES.keys.each_with_index { |k, idx| puts "#{idx + 1}. #{k}" }

      difficulty = nil
      loop do
        difficulty = gets.chomp.to_i
        break if difficulty.between?(1, STRATEGIES.size)
        prompt(:invalid)
      end

      STRATEGIES[STRATEGIES.keys[difficulty - 1]]
    end

    def create_board
      @board = Board.new(options[:grid_size])
    end

    def create_main_player
      @players = [Human.new(options[:player][:name],
                            options[:player][:marker],
                            board)]
    end

    def create_opponents
      options[:opponents].each do |opponent|
        @players <<
          if opponent[:type] == 'human'
            Human.new(opponent[:name], opponent[:marker], board)
          else
            Computer.new(opponent[:name], opponent[:marker], board,
                         opponent[:strategy].new(board, opponent[:marker]))
          end
      end
    end

    def choose_first_turn
      prompt(:first)
      display_players

      first = nil
      loop do
        first = gets.chomp.to_i
        break if first.between?(1, players.count + 1)
        prompt(:invalid)
      end

      define_player_order(first)
    end

    def display_players
      players.each_with_index do |player, idx|
        puts "#{idx + 1}. #{player.name}"
      end
      puts "#{players.count + 1}. Select at random"
    end

    def define_player_order(first)
      if first == players.count + 1
        players.shuffle!
      elsif first != 1
        players.unshift(players.delete_at(first - 1))
      end
    end
  end

  class TTTGame
    include TTT
    include Notifier

    def initialize
      load_messages
    end

    def play
      welcome_and_configure

      loop do
        main_game
        board.display_final

        break unless play_again?
        board.reset_score
      end

      goodbye_message
    end

    private

    def welcome_and_configure
      welcome_message

      @config = Configuration.new
      @config.configure

      @board = @config.board
      @players = @config.players
    end

    attr_reader :board

    def welcome_message
      clear_screen
      prompt(:welcome, { rounds: Configuration::WINS_PER_GAME.to_s })
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

    def main_game
      until board.max_score >= Configuration::WINS_PER_GAME
        board.display_board

        player_turns

        board.display_result

        prompt(:enter)
        gets

        @players.rotate!
        board.reset_board
      end
    end

    def player_turns
      @players.cycle do |player|
        player.move
        break if board.winner_found? || board.full?
        board.display_board
      end
    end
  end
end

TTT::TTTGame.new.play
