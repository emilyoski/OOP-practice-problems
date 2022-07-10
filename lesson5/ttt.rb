module ReadableOutput
  def joinor(option, punct = ",", word = "or")
    option.map!(&:to_s)
    choices = option.length

    if choices < 2
      option[0]
    elsif choices < 3
      option[0] + " #{word} " + option[1]
    else
      option[0, (choices - 1)].join("#{punct} ") + " #{word} " + option[-1]
    end
  end

  def clear
    system "clear"
  end
end

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  # ======================================================================
  # method used to identify if a line has 2 identical markers
  #   and an unmarked square in the row
  # this means there is a potential for a 'strategic' move
  # ======================================================================
  def move_required?(chosen_marker)
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if two_identical_markers?(squares, chosen_marker)
        return true
      end
    end
    false
  end

  # ======================================================================
  # method used to determine the line with the available move
  # ======================================================================
  def determine_line_for_move(chosen_marker)
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if two_identical_markers?(squares, chosen_marker)
        return line
      end
    end
  end

  def find_empty_square_for_move(chosen_marker)
    line = determine_line_for_move(chosen_marker)
    line.each do |key|
      if @squares[key].unmarked?
        return key
      end
    end
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end

  def two_identical_markers?(squares, chosen_marker)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 2
    (markers.min == markers.max) && (markers.min == chosen_marker)
  end
end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  include ReadableOutput
  @@potential_markers = ('A'..'Z').to_a

  COMPUTER_NAMES = ['R2D2', 'Gru', 'The Mad Scientist', 'Mac Attack']

  attr_reader :marker, :name, :player_type
  attr_accessor :score

  def initialize(player_type)
    @player_type = player_type
    @score = 0
    @first_to_move = nil
    set_name
    set_marker
  end

  def add_win_to_score
    self.score += 1
  end

  private

  attr_writer :marker, :name
  attr_accessor :potential_markers

  # ======================================================================
  # methods to set the name and marker of the player
  # a class variable was utilized so each player will have an unique marker
  # ======================================================================
  def set_name
    @name = if player_type == :human
              prompt_set_name
            else
              COMPUTER_NAMES.sample
            end
  end

  def set_marker
    @marker = if player_type == :human
                prompt_set_marker
              else
                mark = @@potential_markers[rand(@@potential_markers.size - 1)]
                @@potential_markers.delete(mark)
                mark
              end
  end

  # ======================================================================
  # methods to prompt the human player for their name and marker
  # ======================================================================
  def prompt_set_name
    clear
    puts "What's your name?"
    gets.chomp.capitalize
  end

  def prompt_set_marker
    clear
    puts "Select one of the letters to be your marker: "
    puts joinor(@@potential_markers)
    puts "What is your choice?"
    mark = gets.chomp.capitalize
    @@potential_markers.delete(mark)
    mark
  end
end

class TTTGame
  include ReadableOutput

  GAMES_TO_WIN = 5

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(:human)
    @computer = Player.new(:computer)
    @current_marker = nil
    @difficulty = nil
  end

  def play
    clear
    display_welcome
    main_game
    display_goodbye
  end

  private

  attr_accessor :difficulty, :current_marker, :first_to_move

  def main_game
    set_up_game
    loop do
      display_board
      player_moves
      display_result
      update_and_display_score
      break if overall_game_wins_achieved? || quit_playing?
      reset
      display_play_again_message
    end
  end

  # ======================================================================
  # methods for set up of game
  # ======================================================================
  def display_welcome
    display_welcome_message
    loop do
      break if skip_rules?
      display_rules
      break if ready_to_play?
    end
    clear
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end

  def skip_rules?
    puts "Do you want to skip the rules and start playing? (y/n)"
    answer = gets.chomp.downcase
    return true if answer == 'y'
  end

  def display_rules
    puts "The rules of Tic Tac Toe are:\n" + RULES
  end

  RULES = <<-MSG
    => This game is played on a grid that's 3 squares by 3 squares.
    => X and O is the default. However, you will select your marker
         and the computer's marker will be a random letter.
    => You will select the difficulty level of the computer (easy or hard).
         In easy, only defensive plays will be selected by the computer.
         In hard, OFFENSIVE and defensive plays will be selected.
    => The first player to get 3 of their marks in a row is the winner.
         The row can be up, down, across or diagonal
    => When all 9 squares are full without a player getting 3 marks in a row,
         the game ends in a tie.
    => The first player to #{GAMES_TO_WIN} wins will win the game! \n
  MSG

  def ready_to_play?
    puts "Are you ready to start playing? (y/n)"
    answer = gets.chomp.downcase
    return true if answer == 'y'
  end

  def set_up_game
    set_game_difficulty
    clear
    decide_first_player
    clear
  end

  def set_game_difficulty
    puts "Set the difficulty level of your opponent, #{computer.name}."
    puts "Difficulty level: "
    puts "=> Easy or Hard? "
    answer = gets.chomp.downcase
    self.difficulty = if answer == 'hard'
                        'hard'
                      else
                        'easy'
                      end
  end

  def decide_first_player
    puts "Do you want to decide who goes first? (y/n)"
    answer = gets.chomp.downcase
    self.current_marker = if answer == 'y'
                            set_first_player
                          else
                            [human.marker, computer.marker].sample
                          end
    self.first_to_move = current_marker
  end

  def set_first_player
    answer = nil
    loop do
      puts "Who will go first?"
      puts "#{human.name}, Player (p) or #{computer.name}, Computer (c)?"
      answer = gets.chomp.downcase
      break if %w(p c).include?(answer)
      puts "That was not a valid player option."
      puts "Please select (p) for Player or (c) for Computer."
    end

    answer == 'p' ? human.marker : computer.marker
  end

  # ======================================================================
  # methods relating to player moves
  # ======================================================================
  def player_moves
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
    end
  end

  def display_unmarked_keys
    puts "Choose a square for your move: "
    puts "=> #{joinor(board.unmarked_keys)}"
  end

  def human_turn?
    @current_marker == human.marker
  end

  def human_moves
    display_unmarked_keys
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    move = determine_computer_move(computer.marker, human.marker, difficulty)
    board[move] = computer.marker
  end

  # ======================================================================
  # first conditional is evaluating if an offensive move is available
  #   and the player chose a 'hard' difficulty level
  # second conditional is evaluating if a defensive move is needed
  # ======================================================================
  def determine_computer_move(offensive_marker, defensive_marker, diff_lvl)
    if board.move_required?(offensive_marker) && diff_lvl == 'hard'
      board.find_empty_square_for_move(offensive_marker)
    elsif board.move_required?(defensive_marker)
      board.find_empty_square_for_move(defensive_marker)
    elsif board.unmarked_keys.include?(5)
      5
    else
      board.unmarked_keys.sample
    end
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = computer.marker
    else
      computer_moves
      @current_marker = human.marker
    end
  end

  # ======================================================================
  # methods related to scoring
  # ======================================================================
  def update_and_display_score
    update_score
    display_score
  end

  def update_score
    case board.winning_marker
    when human.marker
      human.add_win_to_score
    when computer.marker
      computer.add_win_to_score
    end
  end

  # ======================================================================
  # methods related to display during the game
  # ======================================================================
  def display_score
    puts "==========SCORES=============\n"
    puts "#{human.name} has #{human.score} wins."
    puts "#{computer.name} has #{computer.score} wins."
    puts "============================="
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_board
    puts "You're a #{human.marker}. Computer is a #{computer.marker}."
    puts ""
    board.draw
    puts ""
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      puts "You won!"
    when computer.marker
      puts "Computer won!"
    else
      puts "It's a tie!"
    end
  end

  # ======================================================================
  # methods related to resetting the game before the next
  # ======================================================================

  def reset
    board.reset
    @current_marker = first_to_move
    clear
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end

  # ======================================================================
  # methods relating to game conclusion
  # ======================================================================
  def overall_game_wins_achieved?
    human.score == GAMES_TO_WIN || computer.score == GAMES_TO_WIN
  end

  def quit_playing?
    answer = nil
    loop do
      puts "Would you like to continue playing? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end

    answer == 'n'
  end

  def display_goodbye
    clear
    display_score
    display_overall_winner if overall_game_wins_achieved?
    puts ""
    display_goodbye_message
  end

  def display_overall_winner
    if human.score == GAMES_TO_WIN
      puts "#{human.name} is the champion of Tic Tac Toe!"
      puts "Crushed it!"
    elsif computer.score == GAMES_TO_WIN
      puts "#{computer.name} is the champion of Tic Tac Toe!"
      puts "That's rough..."
    end
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end
end

game = TTTGame.new
game.play
