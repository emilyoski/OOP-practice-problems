###########################################
### modules, method lookup path

module TeethPullable
  def pull_teeth
    "pulling teeth"
  end
end

class Dentist
  attr_reader :dental_school_graduate

  def initialize(name)
    @dental_school_graduate = true
    @name = name
  end
end

class OralSurgeon < Dentist
  include TeethPullable

  def place_implants
    "placing an implant"
  end
end

class Orthodontists < Dentist
  def straighten_teeth
    "straightening your teeth"
  end
end

class GeneralDentist < Dentist
  include TeethPullable

  def fill_teeth
    "filling your teeth"
  end
end

###########################################
##### method access control

class Person
  attr_accessor :name

  def initialize(name, weight)
    @name = name
    @weight = weight
  end

  def display_weight
    puts "You can't ask for someone's weight!"
  end

  def medical_request_display_weight
    weight
  end

  def to_s
    "I'm #{name}."
  end

  private

  attr_reader :weight
end

###########################################
####### method access control, self

class Person
  attr_reader :name, :height

  def initialize(name, height)
    @name = name
    @height = height
  end

  def update_height(new_height)
    self.height = new_height
  end

  def to_s
    "I'm #{name}. I'm #{height} tall."
  end

  private

  attr_writer :height
end

###########################################
##### polymorphism, inheritance, classes

class MustacheCharacter
  attr_accessor :clothing_color, :name

  def initialize(color, name)
    @clothing_color = color
    @name = name
  end

  def jump
    "jumping in the air!"
  end

  def throw_shell
    "throwing a #{clothing_color} shell!"
  end

  def defeat_enemy
    "defeating the enemy!"
  end
end

class Mario < MustacheCharacter
  def initialize
    super("red", "Mario")
  end

  def defeat_enemy
    "defeating the enemy by punching them!"
  end
end

class Luigi < MustacheCharacter
  def initialize
    super("green", "Luigi")
  end

  def defeat_enemy
    "defeating the enemy by kicking them!"
  end
end

###########################################
#### duck typing, polymorphism

class Circle
  def initialize(radius)
    @radius = radius
  end

  def draw
    "drawing a circle"
  end
end

class Rectangle
  def initialize(width, length)
    @width = width
    @length = length
  end

  def draw
    "drawing a rectangle"
  end
end

class Triangle
  def initialize(length)
    @length = length
  end

  def draw
    "drawing a triangle"
  end
end

shapes = [Circle.new(5), Rectangle.new(2,5), Triangle.new(5)]

shapes.each { |shape| puts shape.draw }

##############################################
###### self, class variables 

class Circle
  @@number_of_circles = 0

  def initialize(radius)
    @radius = radius
    @@number_of_circles += 1
  end

  def draw
    "drawing a circle"
  end

  def self.count
    @@number_of_circles
  end
end

##############################################
###### fake operators 

class Pet
  attr_reader :name

  def initialize(name, weight)
    @name = name
    @weight = weight
  end

  def >(other_pet)
    weight > other_pet.weight
  end

  def <(other_pet)
    weight < other_pet.weight
  end

  protected

  attr_reader :weight
end

bob = Pet.new('bob', 50)
bill = Pet.new('bill', 60)

puts "bob weighs more" if bob > bill
puts "bill weighs more" if bob < bill
