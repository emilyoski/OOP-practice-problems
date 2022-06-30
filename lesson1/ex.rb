class GoodDog
  attr_accessor :name, :height, :weight 
  
  def initialize(name, height, weight)
    @name = name
    @height = height
    @weight = weight
  end

  def speak
    "#{@name} says arf!"
  end
end

sparky = GoodDog.new("Sparky", 12, 35)
puts sparky.speak
puts sparky.name
puts sparky.height
puts sparky.weight
sparky.name = "Spartacus"
sparky.height = 24
sparky.weight = 70
puts sparky.name
puts sparky.height
puts sparky.weight
