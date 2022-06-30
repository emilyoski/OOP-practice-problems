class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = 0
  end

  def increment_score
    @score += 1
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
      puts "Please choose rock, paper, or scissors: "
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors']

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (paper? && other_move.rock?) ||
      (scissors? && other_move.paper?)
  end

  def <(other_move)
    (rock? && other_move.paper?) ||
      (paper? && other_move.scissors?) ||
      (scissors? && other_move.rock?)
  end

  def to_s
    @value
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

  def display_moves
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

  def display_game_status(winner)
    display_moves
    display_winner(winner)
    display_scores
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
      human.choose
      computer.choose
      winner = determine_winner
      update_scores(winner)
      display_game_status(winner)
      break if win_points_hit? || done_playing?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
