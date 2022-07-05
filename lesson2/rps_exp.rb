require 'colorize'

class Player
  attr_accessor :move, :name, :score, :moves_used

  def initialize
    set_name
    @score = 0
    @moves_used = []
  end

  def increment_score
    @score += 1
  end

  # execute all methods needed for a move
  def execute_move
    choose
    record_move
  end

  private

  # create appropriate object based on move selected by player
  def obtain_move(choice)
    case choice
    when 'rock' then Rock.new
    when 'paper' then Paper.new
    when 'scissors' then Scissors.new
    when 'lizard' then Lizard.new
    when 'spock' then Spock.new
    end
  end

  def record_move
    moves_used << move.value
  end
end

class Human < Player
  def set_name
    n = nil
    loop do
      puts "What's your name?".red
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value.".red
    end
    self.name = n
  end

  private

  VALID_USER_MOVE_INPUTS = ['r', 'p', 'sc', 'l', 'sp']
  PLAYER_SELECT_PROMPT = <<-MSG
    Please choose:
      Rock (r)
      Paper (p)
      Scissors (sc)
      Lizard (l)
      Spock (sp)
  MSG

  def choose
    choice = nil
    loop do
      user_input = obtain_valid_user_input
      choice = user_input_to_move(user_input)
      break if Move::VALUES.include?(choice)
    end
    self.move = obtain_move(choice)
  end

  # methods to validate and standardize user input
  def obtain_valid_user_input
    input = nil
    loop do
      break if VALID_USER_MOVE_INPUTS.include?(input)
      puts PLAYER_SELECT_PROMPT.cyan
      input = gets.chomp.downcase

      if input == 's'
        puts "Did you mean scissors (sc) or spock (sp)?".cyan
        input = gets.chomp.downcase
      elsif !VALID_USER_MOVE_INPUTS.include?(input)
        puts "Sorry, invalid choice.".cyan
      end
    end
    input
  end

  def user_input_to_move(input)
    case input
    when 'r' then 'rock'
    when 'p' then 'paper'
    when 'sc' then 'scissors'
    when 'l' then 'lizard'
    when 'sp' then 'spock'
    end
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  private

  HAL_OPTIONS = ['scissors', 'scissors', 'scissors', 'scissors', 'rock']
  CHAP_OPTIONS = ['spock', 'spock', 'lizard', 'paper', 'rock', 'scissors']
  SON_OPTIONS = ['paper', 'lizard']

  def choose
    self.move = obtain_move(personality_move)
  end

  # move depending on which robot is used as the computer
  def personality_move
    case name
    when 'R2D2' then 'rock'
    when 'Hal' then HAL_OPTIONS.sample
    when 'Chappie' then CHAP_OPTIONS.sample
    when 'Sonny' then SON_OPTIONS.sample
    when 'Number 5' then Move::VALUES.sample
    end
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  WIN_OVER = { 'rock' => ['scissors', 'lizard'],
               'paper' => ['rock', 'spock'],
               'scissors' => ['paper', 'lizard'],
               'lizard' => ['spock', 'paper'],
               'spock' => ['scissors', 'rock'] }

  LOSE_TO = { 'rock' => ['paper', 'spock'],
              'paper' => ['scissors', 'lizard'],
              'scissors' => ['spock', 'rock'],
              'lizard' => ['scissors', 'rock'],
              'spock' => ['lizard', 'paper'] }

  attr_reader :value

  def >(other_move)
    return true if WIN_OVER[value].include?(other_move.value)
    false
  end

  def <(other_move)
    return true if LOSE_TO[value].include?(other_move.value)
    false
  end

  def to_s
    @value
  end
end

class Rock < Move
  def initialize
    @value = 'rock'
  end
end

class Paper < Move
  def initialize
    @value = 'paper'
  end
end

class Scissors < Move
  def initialize
    @value = 'scissors'
  end
end

class Lizard < Move
  def initialize
    @value = 'lizard'
  end
end

class Spock < Move
  def initialize
    @value = 'spock'
  end
end

class Game
  WIN_POINTS = 5

  # general methods for user experience
  def clear_screen
    system 'clear'
  end

  def wait
    sleep 1
  end

  # general game name and rules
  def game_name
    "the Game!"
  end

  def rules
    "Obtain the winning criteria. Defeat your opponent!"
  end

  # display methods for the game
  def display_welcome
    display_welcome_message
    display_rules
    display_win_points
    wait
    prompt_questions
    clear_screen
  end

  def display_welcome_message
    puts "Welcome to #{game_name}".red
  end

  def display_rules
    puts "Do you want to hear the rules?".red
    ans = gets.chomp.downcase
    return unless ans == 'yes'
    puts "The following rules apply for this game: #{rules}".red
  end

  def display_win_points
    puts "First player to hit #{WIN_POINTS} is the winner!".red
  end

  def prompt_questions
    loop do
      puts "Do you have any questions before we begin?".red
      ans = gets.chomp.downcase
      break if ans == 'no'
      display_rules
    end
  end

  def display_goodbye_message
    puts "Thanks for playing the #{game_name}! Good bye!".red
  end

  # general game ending condition for player to exit game
  def done_playing?
    answer = nil
    loop do
      puts "Would you like to continue playing? (y/n)".red
      answer = gets.chomp
      break if ['y', 'n'].include?(answer.downcase)
      puts "Sorry, must be y or n.".red
    end

    return false if answer.downcase == 'y'
    return true if answer.downcase == 'n'
  end
end

class RPSGame < Game
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
    display_welcome
  end

  def game_name
    "Rock, Paper, Scissors, Lizard, Spock"
  end

  def rules
    "\nEach player will select a move from:
    rock, paper, scissors, lizard, spock. \n \n
    The following are winning combinations against your opponent! \n
    Rock beats lizard and scissors.
    Paper beats rock and spock.
    Scissors beats paper and lizard.
    Lizard beats spock and paper.
    Spock beats scissors and rock.\n"
  end

  # determining the winner; utilize the winner for other methods
  def determine_winner
    if human.move > computer.move
      human
    elsif human.move < computer.move
      computer
    end
  end

  # display methods for game specific play
  def display_current_moves
    puts "#{human.name} chose #{human.move}.".cyan
    puts "#{computer.name} chose #{computer.move}.".cyan
  end

  def display_winner(winner)
    case winner
    when human
      puts "#{human.name} won!".cyan
    when computer
      puts "#{computer.name} won!".cyan
    else
      puts "It's a tie!".cyan
    end
  end

  def display_scores
    puts "#{human.name} has #{human.score} wins.".cyan
    puts "#{computer.name} has #{computer.score} wins.".cyan
  end

  def display_historical_moves
    puts "#{human.name} has chosen the following moves so far: ".cyan
    puts human.moves_used.join(', ').cyan
    puts "#{computer.name} has chosen the following moves so far: ".cyan
    puts computer.moves_used.join(', ').cyan
  end

  def display_game_status(winner)
    display_current_moves
    display_winner(winner)
    wait
    clear_screen
    puts "=============SCOREBOARD===========\n".cyan
    display_scores
    puts "\n=============GAME HISTORY=========\n".cyan
    display_historical_moves
    puts "\n==================================".cyan
  end

  # update scores dependant upon the winner
  def update_scores(winner)
    case winner
    when human
      human.increment_score
    when computer
      computer.increment_score
    end
  end

  # game ending condition
  def win_points_hit?
    (human.score == Game::WIN_POINTS) || (computer.score == Game::WIN_POINTS)
  end

  # RPS game loop
  def play
    loop do
      human.execute_move
      computer.execute_move
      winner = determine_winner
      update_scores(winner)
      display_game_status(winner)
      break if win_points_hit? || done_playing?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
