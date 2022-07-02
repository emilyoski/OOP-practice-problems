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

  def execute_move
    choose
    record_move
  end
end

class Human < Player
  def set_name
    n = nil
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, scissors, lizard, or spock: "
      choice = gets.chomp.downcase
      break if Move::VALUES.include?(choice)
      puts "Sorry, invalid choice."
    end
    self.move = obtain_move(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = obtain_move(Move::VALUES.sample)
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
  def display_welcome_message
    puts "Welcome to the Game!"
  end

  def display_goodbye_message
    puts "Thanks for playing the Game! Good bye!"
  end

  def done_playing?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include?(answer.downcase)
      puts "Sorry, must be y or n."
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
    display_welcome_message
  end

  def determine_winner
    if human.move > computer.move
      human
    elsif human.move < computer.move
      computer
    end
  end

  def display_current_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_winner(winner)
    case winner
    when human
      puts "#{human.name} won!"
    when computer
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def display_scores
    puts "#{human.name} has #{human.score} wins."
    puts "#{computer.name} has #{computer.score} wins."
  end

  def display_historical_moves
    puts "#{human.name} has chosen the following moves so far: "
    puts human.moves_used.join(', ')
    puts "#{computer.name} has chosen the following moves so far: "
    puts computer.moves_used.join(', ')
  end

  def display_game_status(winner)
    display_current_moves
    display_winner(winner)
    sleep 1
    puts "=================================="
    display_scores
    puts "=================================="
    display_historical_moves
    puts "=================================="
  end

  def update_scores(winner)
    case winner
    when human
      human.increment_score
    when computer
      computer.increment_score
    end
  end

  def win_points_hit?
    (human.score == 10) || (computer.score == 10)
  end

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
