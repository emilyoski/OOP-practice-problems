module Walkable
  def walk
    "I'm walking."
  end
end

module Swimmable
  def swim
    "I'm swimming."
  end
end

module Climbable
  def climb
    "I'm climbing."
  end
end

module Danceable
  def dance
    "I'm dancing."
  end
end

class Animal
  include Walkable

  def speak
    "I'm an animal, and I speak!"
  end
end

module GoodAnimals
  include Climbable

  class GoodDog < Animal
    include Swimmable
    include Danceable
  end
  
  class GoodCat < Animal; end
end

good_dog = GoodAnimals::GoodDog.new
p good_dog.walk

On `line 44` we assign `good_dog` to an instance of the `GoodDog` class which is contained in the `GoodAnimals` module. On `line 45` we call the `p` method on the return value of calling the `good_dog#walk` instance method. 

The method look up path will search the `GoodDog` class first for the `walk` instance method. The method is not in the `GoodDog` class and then will look at the modules mix-ins in the `GoodDog` class and will search them in the reverse order from which they are listed. The `walk` instance method is not defined in the `Danceable` or `Swimmable` module. After looking there, Ruby will search the superclass `Animal` from which `GoodDog` inherits from. The `Animal` class does not define a `walk` instance method. Ruby will then search the modules mixed in the `Animal` class which is the `Walkable` module. The `Walkable` module does define a `walk` instance method which is then invoked and returns the string `I'm walking` which is outputted by the `p` method. 

class Animal
  def eat
    puts "I eat."
  end
end

class Fish < Animal
  def eat
    puts "I eat plankton."
  end
end

class Dog < Animal
  def eat
     puts "I eat kibble."
  end
end

def feed_animal(animal)
  animal.eat
end

array_of_animals = [Animal.new, Fish.new, Dog.new]
array_of_animals.each do |animal|
  feed_animal(animal)
end

On `line 73` we have initialized and assigned `array_of_animals` to the array object containing an instance of the `Animal`, `Fish`, `Dog` classes. On `line 74`, we have invoked the `each` method on the `array_of_animals` and passed each instance of the `Animal`, `Fish`,`Dog` classes as an argument to the `feed_animal` method. From the `feed_animal` method definition, we can see on `line 70` that we will call the `eat` method on each instance of the class passed to `feed_animal` as an argument.

To understand the output from this, we must look at the `eat` instance method in each of the classes. `Animal` class has an `eat` instance method which will output the string `I eat` and return nil. The `Fish` class is a subclass of the `Animal` superclass which means that it will inherit the `eat` instance method we have just described on `line 53`. However, the `Fish` class also has an `eat` instance method that will override the `eat` instance method defined in the `Animal` class. Thus when we invoke the `eat` method on `line 70` for the instance of the `Fish` class, we will invoke the `eat` instance method on `line 58` which outputs the string object `I eat plankton` and returns nil. The `Dog` class is also a subclass of the `Animal` superclass and same as the `Fish` class, has defined its own `eat` instance method which will override the `eat` instance method in its superclass `Animal`. Thus, when the instance of the `Dog` class is passed as an argument in `feed_animal` method and `eat` method is invoked - we will invoke the `eat` instance method on `line 64` and output the string object `I eat kibble` and return nil. 

This code demonstrates polymorphism because we have different classes/data types that are able to respond to a common interface which is the `eat` method invocation in this case. This demonstration is polymorphism through inheritance because the `eat` instance method is defined in the superclass `Animal` and inherited by all of its subclasses. The subclasses do override this method by providing its own `eat` instance method which provides a more specific `eat` instance method. 

class Person
  attr_accessor :name, :pets

  def initialize(name)
    @name = name
    @pets = []
  end
end

class Pet
  def jump
    puts "I'm jumping!"
  end
end

class Cat < Pet; end

class Bulldog < Pet; end

bob = Person.new("Robert")

kitty = Cat.new
bud = Bulldog.new

bob.pets << kitty
bob.pets << bud                     

bob.pets.jump 

This code will raise an error on `line 111` because we have invoked the `jump` instance method on `bob.pets` which will return an array object containing the `kitty` and `bud`. There is not a `jump` instance method defined for the array class thus we will receive an error. The `pets` method is actually a getter method which will return the instance variable `@pets` which is an array object. We call `<<` on `line 108` to mutate this array object to now include the `kitty` object and again on `line 109` to mutate this array object again to include the `bud` object. 

This code will work if we incorporate the `each` method like so `bob.pets.each { |animal| animal.jump }`. Adding the `each` method will allow us to iterate through the array object referenced by the `@pets` instance variable and invoke the `jump` instance method on each object. `kitty` is an instance of the `Cat` class which inherits from the `Pet` class and `bud` is an instance of the `Bulldog` class which also inherits from the `Pet` class. The `Pet` superclass has a `jump` instance method defined on `line 94-96` and will therefore be inherited by both subclasses. 

`kitty` and `bob` are considered collaborator objects because they are objects which are utilized in the state of another object which is the `Person` class in this case. 

class Animal
  def initialize(name)
    @name = name
  end
end

class Dog < Animal
  def initialize(name); end

  def dog_name
    "bark! bark! #{@name} bark! bark!"
  end
end

teddy = Dog.new("Teddy")
puts teddy.dog_name  

On `line 133` we have assigned `teddy` to an instance of the `Dog` class and passed in the argument `Teddy`. The argument `Teddy` will be passed to the `initialize` method in the `Dog` class which is defined on `line 126`. This `initialize` method accepts the argument but does not do anything with the value as we can see there is no code in the method body of `initialize` on `line 126`. 

On `line 134` we call the `puts` method on the return value of the `dog_name` instance method call on the `teddy` object. The return value of `teddy#dog_name` is the `"bark! bark! #{@name} bark! bark!"`. The string interpolation of the instance variable `@name` will be `nil` because the `@name` instance variable was not initialized and assigned to a value. Thus the return value passed as an argument to `puts` on `line 134` will be `bark! bark! bark! bark!` which will be output and `nil` is returned from the `puts` method call. 

This code demonstrates that uninitialized instance variables are `nil` and we must initialize our instance variable. 