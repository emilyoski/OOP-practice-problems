module DisplayableOptions
  def clear
    system 'clear'
  end

  def wait
    sleep 2
  end
end

class Participant
  attr_accessor :hand, :score, :total
  attr_reader :name

  def initialize
    @hand = []
    @score = 0
    @total = 0
    @name = set_name
  end

  def dealt(card)
    hand << card
    self.total = update_running_total
  end

  def hit(card)
    puts "#{name} chose to hit!"
    hand << card
    self.total = update_running_total
  end

  def reset_hand
    self.hand = []
  end

  def busted?
    total > Game::WINNING_SCORE
  end

  def add_win_to_score
    self.score += 1
  end

  private

  def update_running_total
    scores = transform_cards_to_scores(hand)
    running_total = calculate_total_without_aces(scores)
    add_aces_to_total(scores, running_total)
  end

  def transform_cards_to_scores(cards)
    cards.map do |card|
      if card.value == 'Ace'
        'Ace'
      else
        card.score
      end
    end
  end

  def calculate_total_without_aces(card_scores)
    total = 0

    card_scores.each do |score|
      if score != 'Ace'
        total += score
      end
    end
    total
  end

  def add_aces_to_total(card_scores, total)
    card_scores.count('Ace').times do |_|
      total += if (total + 11) > Game::WINNING_SCORE
                 Card::SCORES['Ace'][0]
               else
                 Card::SCORES['Ace'][1]
               end
    end
    total
  end
end

class Player < Participant
  def set_name
    puts "Whats your name?"
    gets.chomp.strip.capitalize
  end
end

class Dealer < Participant
  def set_name
    "Dealer"
  end
end

class Deck
  VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10',
            'Jack', 'Queen', 'King', 'Ace']
  SUITS = ['Hearts', 'Diamonds', 'Spades', 'Clubs']

  attr_accessor :cards

  def initialize
    @cards = []

    SUITS.each do |suit|
      VALUES.each do |value|
        @cards << Card.new(value, suit)
      end
    end
  end

  def deal_card
    shuffle
    cards.pop
  end

  private

  def shuffle
    cards.shuffle!
  end
end

class Card
  SCORES = { '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6,
             '7' => 7, '8' => 8, '9' => 9, '10' => 10, 'Jack' => 10,
             'Queen' => 10, 'King' => 10, 'Ace' => [1, 11] }

  attr_reader :value, :suit, :score

  def initialize(value, suit)
    @value = value
    @suit = suit
    @score = SCORES[value]
  end
end

class Game
  include DisplayableOptions

  WINNING_SCORE = 21
  DEALER_STOP = 17
  MATCHES_TO_WIN = 3
  attr_accessor :player, :dealer, :deck

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def play
    set_up_game
    main_game
    close_game
  end

  private

  # ======================================================================
  # methods relating to game set up
  # ======================================================================

  def set_up_game
    clear
    display_welcome_message
    display_rules
    display_scoring_rules
    key_to_continue
    clear
  end

  def display_welcome_message
    puts "Welcome to the Game of 21!\n"
  end

  def display_rules
    puts RULES
  end

  RULES = <<-MSG
  => The rules of 21 are simple. You will begin with a standard 52 card deck.
  => The goal is to try to get as close to #{WINNING_SCORE} as possible,
       without going over. 
  => If you go over #{WINNING_SCORE}, it's a bust and you lose.
  => You, as the player, will go first followed by the dealer's turn.
  => You can hit (receive another card) or stay (maintain your current cards).
  => Dealer will then take their turn.
  => Scores will be compared and winner will be determined.
  => 21 Champion is first player to #{MATCHES_TO_WIN} wins!
  => House rules - ties will go to the dealer!

  MSG

  def display_scoring_rules
    puts "The scoring is calculated from the following scoring: "
    puts SCORING_RULES
  end

  SCORING_RULES = <<-MSG

  CARD                  |     VALUE
  2 - 10                |     face value
  jack, queen, king     |     10
  ace                   |     1 or 11

  MSG

  def key_to_continue
    puts "Lets play! Hit ENTER to continue."
    gets.chomp
  end

  # ======================================================================
  # methods relating to main game loop
  # ======================================================================

  def main_game
    loop do
      initial_deal
      player_turn
      show_cards_for_result
      dealer_turn unless player.busted?
      show_result_score_winner
      break if overall_match_winner? || done_playing?
      reset
    end
  end

  # ======================================================================
  # methods relating to initial deal
  # ======================================================================

  def initial_deal
    display_scoring_rules
    deal_cards
    show_cards_for_play
  end

  def deal_cards
    2.times { |_| player.dealt(deck.deal_card) }
    2.times { |_| dealer.dealt(deck.deal_card) }
  end

  # ======================================================================
  # methods relating to displaying cards
  # ======================================================================

  def show_cards_for_play
    puts "Player has: \n"
    puts show_all_cards(player.hand) + " for a total of: #{player.total}."
    puts "\nDealer has: \n"
    puts show_first_card(dealer.hand)
  end

  def show_cards_for_result
    puts "Player has: \n \n #{show_all_cards(player.hand)} " \
         "for a total of: #{player.total}."
    #puts show_all_cards(player.hand) + " for a total of: #{player.total}."
    puts "\nDealer has: \n"
    puts show_all_cards(dealer.hand) + " for a total of: #{dealer.total}."
    puts "==============================================================="
  end

  def show_all_cards(cards)
    cards.map { |card| "#{card.value} of #{card.suit}" }.join(", ")
  end

  def show_first_card(cards)
    "#{cards[0].value} of #{cards[0].suit} and unknown card."
  end

  # ======================================================================
  # methods relating to player turns
  # ======================================================================

  def player_turn
    loop do
      choice = prompt_player_hit_or_stay
      clear
      break if choice == 'stay'
      player.hit(deck.deal_card)
      display_scoring_rules
      show_cards_for_play
      break if player.busted?
    end
  end

  def prompt_player_hit_or_stay
    answer = nil

    loop do
      puts "=> Would you like to hit or stay?"
      answer = gets.chomp.downcase
      break if %w(hit stay).include?(answer)
      puts "That's an invalid input. Please choose hit or stay."
    end

    answer
  end

  def dealer_turn
    loop do
      break if dealer.total >= DEALER_STOP
      dealer.hit(deck.deal_card)
      wait
      clear
      show_cards_for_result
      wait
      break if dealer.busted?
    end
  end

  # ======================================================================
  # methods relating to game outcome
  # ======================================================================

  # house rules in this game means that ties go to the dealer
  def determine_winner
    if dealer.busted? || (player.total > dealer.total && !player.busted?)
      player
    else
      dealer
    end
  end

  def determine_busted
    return player if player.busted?
    return dealer if dealer.busted?
  end

  def overall_match_winner?
    player.score == MATCHES_TO_WIN || dealer.score == MATCHES_TO_WIN
  end

  def determine_overall_winner
    return player if player.score == MATCHES_TO_WIN
    return dealer if dealer.score == MATCHES_TO_WIN
  end

  # ======================================================================
  # methods relating to game scoring
  # ======================================================================

  def update_score
    case determine_winner
    when player
      player.add_win_to_score
    when dealer
      dealer.add_win_to_score
    end
  end

  def display_scores
    puts "             SCORES              \n"
    puts "#{player.name}: #{player.score} wins."
    puts "#{dealer.name}: #{dealer.score} wins."
    puts "-----------------------------------"
  end

  # ======================================================================
  # methods relating to game reset
  # ======================================================================

  def reset
    clear
    reset_hands
  end

  def reset_hands
    player.reset_hand
    dealer.reset_hand
  end

  # ======================================================================
  # methods relating to game conclusion
  # ======================================================================

  def done_playing?
    answer = nil

    loop do
      puts "Would you like to continue playing? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y yes n no).include?(answer)
      puts "Sorry, must be yes or no"
    end

    answer == 'n' || answer == 'no'
  end

  def close_game
    clear
    show_final_result
    display_goodbye_message
  end

  def show_result_score_winner
    clear
    show_cards_for_result
    update_score
    display_scores
    display_busted_score
    display_winner
  end

  def show_final_result
    display_scores
    display_overall_winner
  end

  # ======================================================================
  # methods relating to display for game conclusion
  # ======================================================================

  def display_busted_score
    case determine_busted
    when player
      puts "#{player.name} busted!"
    when dealer
      puts "#{dealer.name} busted!"
    end
  end

  def display_winner
    case determine_winner
    when player
      puts "#{player.name} won!"
    when dealer
      puts "#{dealer.name} won!"
    end
  end

  def display_overall_winner
    case determine_overall_winner
    when player
      puts "#{player.name} is the CHAMPION!"
    when dealer
      puts "#{dealer.name} is the champion..try again soon!"
    end
  end

  def display_goodbye_message
    puts "Thanks for playing the Game of 21!"
  end
end

Game.new.play
