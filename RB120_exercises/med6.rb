class GuessingGame
  attr_accessor :number, :guess_count, :guess
  attr_reader :lower_limit, :upper_limit 
  NUMBER_OF_GUESSES = 7

  def initialize(lower, upper)
    @number = nil
    @guess_count = nil
    @guess = nil
    @lower_limit = lower
    @upper_limit = upper
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
    self.number = rand(lower_limit..upper_limit)
    self.guess_count = NUMBER_OF_GUESSES
  end

  def display_guesses_remaining
    puts "You have #{guess_count} guesses remaining."
  end

  def prompt_guess
    loop do
      puts "Enter a number between #{lower_limit} and #{upper_limit}:"
      self.guess = gets.chomp.to_i

      break if (lower_limit..upper_limit).include?(guess)
      puts "Invalid guess."
    end
  end

  def increment_guesses_remaining
    self.guess_count -= 1
  end

  def guess_hint
    puts "Your guess is too low." if (lower_limit...number).include?(guess)
    puts "Your guess is too high." if ((number + 1)..upper_limit).include?(guess)
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

game = GuessingGame.new(10, 50)
game.play
