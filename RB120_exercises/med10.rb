require 'pry'

class Deck
  attr_accessor :deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  def initialize
    reset
  end

  def draw
    reset if deck.empty?
    deck.pop
  end

  private

  def reset
    @deck = []
    RANKS.each do |rank|
      SUITS.each do |suit|
        @deck << Card.new(rank, suit)
      end
    end
    @deck.shuffle!
  end
end

class Card
  include Comparable

  attr_reader :rank, :suit, :score
  SCORES = {2 => 2, 3 => 3, 4 => 4, 5 => 5,
            6 => 6, 7 => 7, 8 => 8, 9 => 9,
            10 => 10, "Jack" => 11, "Queen" => 12,
            "King" => 13, "Ace" => 14}

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
    @score = SCORES[@rank]
  end

  def to_s
    "#{rank} of #{suit}"
  end

  def <=>(other_card)
    score <=> other_card.score
  end
end

class PokerHand
  attr_accessor :hand

  def initialize(deck)
    @hand = []
    5.times { |_| hand << deck.draw }
  end

  def print
    puts hand
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  private

  def royal_flush?
    hand.map { |card| card.score }.inject(:+) == 60 && flush?
  end

  def straight_flush?
    straight? && flush?
  end

  def four_of_a_kind?
    cards_rank = hand.map { |card| card.rank }
    cards_rank.uniq.each do |card|
      return true if cards_rank.count(card) == 4
    end
    false
  end

  def full_house?
    three_of_a_kind? && pair?
  end

  def flush?
    hand.map { |card| card.suit}.uniq.length == 1
  end

  def straight?
    scores = hand.map { |card| card.score }.sort
    (scores[0]..scores[-1]).to_a.inject(:+) == scores.sum
  end

  def three_of_a_kind?
    cards_rank = hand.map { |card| card.rank }
    cards_rank.uniq.each do |card|
      return true if cards_rank.count(card) == 3
    end
    false
  end

  def two_pair?
    pair_count = 0

    cards_rank = hand.map { |card| card.rank }
    cards_rank.uniq.each do |card|
      pair_count += 1 if cards_rank.count(card) == 2
    end

    return true if pair_count == 2
    false
  end

  def pair?
    cards_rank = hand.map { |card| card.rank }
    cards_rank.uniq.each do |card|
      return true if cards_rank.count(card) == 2
    end
    false
  end
end

hand = PokerHand.new(Deck.new)
hand.print
puts hand.evaluate

# Danger danger danger: monkey
# patching for testing purposes.
class Array
  alias_method :draw, :pop
end

# Test that we can identify each PokerHand type.
hand = PokerHand.new([
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
])

puts "Royal Flush Test"
puts hand.evaluate == 'Royal flush'

hand = PokerHand.new([
  Card.new(8,       'Clubs'),
  Card.new(9,       'Clubs'),
  Card.new('Queen', 'Clubs'),
  Card.new(10,      'Clubs'),
  Card.new('Jack',  'Clubs')
])

puts "Straight Flush Test"
puts hand.evaluate == 'Straight flush'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
])

puts "Four of a kind Test"
puts hand.evaluate == 'Four of a kind'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Hearts')
])

puts "Full House Test"
puts hand.evaluate == 'Full house'

hand = PokerHand.new([
  Card.new(10, 'Hearts'),
  Card.new('Ace', 'Hearts'),
  Card.new(2, 'Hearts'),
  Card.new('King', 'Hearts'),
  Card.new(3, 'Hearts')
])

puts "Flush Test"
puts hand.evaluate == 'Flush'

hand = PokerHand.new([
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
])

puts "Straight Test"
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new('Queen', 'Clubs'),
  Card.new('King',  'Diamonds'),
  Card.new(10,      'Clubs'),
  Card.new('Ace',   'Hearts'),
  Card.new('Jack',  'Clubs')
])

puts "Straight Test"
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])

puts "Three of a kind Test"
puts hand.evaluate == 'Three of a kind'

hand = PokerHand.new([
  Card.new(9, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(8, 'Spades'),
  Card.new(5, 'Hearts')
])

puts "Two pair Test"
puts hand.evaluate == 'Two pair'

hand = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
])

puts "Pair Test"
puts hand.evaluate == 'Pair'

hand = PokerHand.new([
  Card.new(2,      'Hearts'),
  Card.new('King', 'Clubs'),
  Card.new(5,      'Diamonds'),
  Card.new(9,      'Spades'),
  Card.new(3,      'Diamonds')
])

puts "High Card Test"
puts hand.evaluate == 'High card'