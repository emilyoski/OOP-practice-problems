class Pet
  def initialize(animal, name)
    @animal = animal
    @name = name
  end

  def name
    "a #{@animal} named #{@name}"
  end
end

class Owner
  attr_reader :name
  attr_accessor :pets
  
  def initialize(name)
    @name = name
    @pets = []
  end

  def pet_adopted(pet)
    self.pets << pet
  end

  def number_of_pets
    @pets.length
  end
end

class Shelter
  attr_accessor :owners
  def initialize
    @owners = []
  end

  def owners_that_adopt(owner)
    if !owners.include?(owner)
      @owners << owner
    end
  end

  def adopt(owner, pet)
    owner.pet_adopted(pet)
    owners_that_adopt(owner)
  end

  def print_adoptions
    @owners.each do |owner|
      puts "#{owner.name} has adopted the following pets:"
      owner.pets.each do |pet|
        puts "#{pet.name}"
      end
    end
  end
end

butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

shelter = Shelter.new
shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)
shelter.print_adoptions
puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."