class GuessingGame
  attr_accessor :number, :guess_count, :guess
  NUMBER_OF_GUESSES = 7
  LOWER_LIMIT = 1
  UPPER_LIMIT = 100

  def initialize
    @number = nil
    @guess_count = nil
    @guess = nil
  end

  def play
    system 'clear'
    start_game
    loop do
      display_guesses_remaining
      prompt_guess
      increment_guesses_remaining
      guess_hint
      break if correct_guess? || too_many_guesses?
    end

    puts determine_result
  end

  def start_game
    self.number = rand(LOWER_LIMIT..UPPER_LIMIT)
    self.guess_count = NUMBER_OF_GUESSES
  end

  def display_guesses_remaining
    puts "You have #{guess_count} guesses remaining."
  end

  def prompt_guess
    loop do
      puts "Enter a number between #{LOWER_LIMIT} and #{UPPER_LIMIT}:"
      self.guess = gets.chomp.to_i

      break if (LOWER_LIMIT..UPPER_LIMIT).include?(guess)
      puts "Invalid guess."
    end
  end

  def increment_guesses_remaining
    self.guess_count -= 1
  end

  def guess_hint
    puts "Your guess is too low." if (LOWER_LIMIT...number).include?(guess)
    puts "Your guess is too high." if ((number + 1)..UPPER_LIMIT).include?(guess)
  end

  def correct_guess?
    guess == number
  end

  def too_many_guesses?
    guess_count <= 0
  end

  def determine_result
    return "You won!" if correct_guess?
    return "You have no more guesses. You lost!" if too_many_guesses?
  end
end

game = GuessingGame.new
game.play