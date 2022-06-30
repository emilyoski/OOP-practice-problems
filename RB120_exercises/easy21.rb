module Moveable
  def walk
    "#{name} " + gait + " forward"
  end
end

class Person
  include Moveable
  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    "strolls"
  end
end

class Cat
  include Moveable
  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    "saunters"
  end
end

class Cheetah
  include Moveable
  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    "runs"
  end
end

class Noble
  include Moveable
  attr_reader :name, :title

  def initialize(name, title)
    @name = name
    @title = title
  end

  def walk
    puts "#{title} " + super
  end

  private

  def gait
    "struts"
  end
end

mike = Person.new("Mike")
mike.walk
# => "Mike strolls forward"

kitty = Cat.new("Kitty")
kitty.walk
# => "Kitty saunters forward"

flash = Cheetah.new("Flash")
flash.walk
# => "Flash runs forward"

byron = Noble.new("Byron", "Lord")
byron.walk
# => "Lord Byron struts forward"