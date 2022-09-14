# Practicing RB129 Code Snippets for the Interview 

(Shift and Command and P -> Markdown: preview to the right to preview what is written)

Code Snippet 3:

`Line 25` calls the `p` method on the output of calling the `sides` method on the `Square` class. This will output 4 because we have called the `sides` class method on the `Square` class. The class method `sides` is defined on `line 10 - 12` and we see the resolution operator used to determine the constant `SIDES`. In this case `self::SIDES`, `self` will refer to the calling object which the `Square` class. Since there is no `SIDES` in the `Square` class, Ruby will search the inheritance chain to resolve the constant. Ruby will find `SIDES` in the superclass, `Quadrilateral` on `line 20` which assigned `SIDES` to `4`. 

`Line 26` calls the `p` method on the output of calling the `sides` method on an instance of the `Square` class. This again will output 4. This is because we have called the instance method `sides` which is defined on `line 14-16`. Looking at `line 15`, we have `self.class::SIDES.` This means that the `self` is in this case is the object (instance of the `Square` class) which we then call the `class` method on which returns the `Square` class. 

Code Snippet 5:

class GoodDog
  attr_accessor :name, :height, :weight

  def initialize(n, h, w)
    @name = n
    @height = h
    @weight = w
  end

  def change_info(n, h, w)
    name = n
    height = h
    weight = w
  end

  def info
    "#{name} weighs #{weight} and is #{height} tall."
  end
end


sparky = GoodDog.new('Spartacus', '12 inches', '10 lbs') 
sparky.change_info('Spartacus', '24 inches', '45 lbs')
puts sparky.info 


On `line 34`, we have assigned `sparky` to an instance of the `GoodDog` class and passed in the arguments `'Spartacus', '12 inches', '10 lbs'`. Those arguments are passed to the `initialize` method when we instantiate the object and the `initialize` method assigns those arguments to the instance variables `name`, `height`, and `weight` respectively. 

On `line 35`, we then call the `change_info` method with the following arguments passed `Spartacus, 24 inches, 45 lbs` on the `sparky` object. Looking at the instance method `change_info` in the class definition of `GoodDog`, we can see that 3 local variables, `name`, `height`, `weight` are assigned the values of the arguments passed to this instance method. This is because in order to invoke the setter method within an instance method, we must call the setter like such `self.name = n`. Because of Ruby's syntactical sugar that allows setter methods to be written `name = n` vice `name=(n)`, Ruby is confusing that with the assignment of a local variable. In order to eliminate that confusion, we must use `self` when calling the setter method within an instance method.

On `line 36` when we invoke the `puts` method on the return value of the instance method `sparky#info`, the output will be `Spartacus weighs 10 lbs and is 12 inches tall.`. This is because within the instance method `sparky.change_info` on `line 35`, we have assigned local variables vice calling the setter method. This means that when we call the getter methods `name` `weight` `height` in the string interpolation of string contained in the instance method `sparky.info`, we will return the instance variables `@name`, `@height` and `@weight` and the values assigned to those variables when we instantiated the `sparky` object. The `puts` method call will return `nil`. 

class Person
  attr_accessor :name

  def initialize(name)
    @name = name
  end
  
  def change_name
    name = name.upcase
  end
end

bob = Person.new('Bob')
p bob.name 
bob.change_name
p bob.name

Code Snippet:

On `line 57`, we have assigned `bob` to an instance of the `Person` class and passed in the argument `'Bob'`. This argument will be passed to the `initialize` method defined on `line 48-50` and will assign the argument to the instance variable `@name`.

On `line 59`, we invoked the instance method `change_name` on the `bob` object. The instance method `change_name` has an error because on `line 53`, we have initialized and assigned the local variable `name` which causes an error when `upcase` method is invoked on the local variable `name`. Ruby's syntactical sugar allows us to write setter methods `name = 'sally'` vice `name=('sally')`. However when a setter method is called inside of a class, Ruby thinks we are doing a local variable assignment. To correct this, we must prepend `self` to the setter method like such `self.name = name.upcase` so Ruby knows we are calling the setter method. With `self` prepended, the setter method will call the `upcase` method on the instance variable `@name` which is called with the getter method. 

Thus on `line 60` the output of calling `p` method on the return value of `bob.name` will be `BOB`. 

class Vehicle
  @@wheels = 4

  def self.wheels
    @@wheels
  end
end

p Vehicle.wheels                             

class Motorcycle < Vehicle
  @@wheels = 2
end

p Motorcycle.wheels                           
p Vehicle.wheels                              

class Car < Vehicle; end

p Vehicle.wheels
p Motorcycle.wheels                           
p Car.wheels  

On `lines 70 - 76`, we have defined the `Vehicle` class which initializes a class variable `@@wheels` and assigns it the integer `4`. We have also defined the class method `self.wheels` which returns the class variable `@@wheels`. 

On `line 78` we invoke the `p` method on the return value of the `Vehicle::wheels` class method which will output the value assigned to the class variable `@@wheels` which is currently `4`. 

On `line 80-82`, we have defined the `Motorcycle` class which subclasses from the `Vehicle` class and reassigns the class variable `@@wheels` to the value `2` on `line 81`. It is important to note that this is a reassignment of the class variable because the superclass and all its associated subclasses ALL share the SAME copy of the class variable. Thus when we invoke the `p` method on the `Motorcycle::wheels` class method on `line 84` and the `Vehicle::wheels` class method on `line 85` - both will return the class variable `@@wheels` which is now assigned to the value of `2`. 

On `line 87`, we defined another class `Car` which also subclasses from `Vehicle` and will share the class variable `@@wheels` as well. Thus when we invoke the `p` method on the `Vehicle::wheels` class method on `line 89`, the `Motorcycle::wheels` class method on `line 90` and the `Car::wheels` class method on `line 91`, we will output the value assigned to the class variable `@@wheels` which is `2`. 

This demonstrates how the superclass and all its associated subclasses all share the same copy of the class variable and why class variables should be avoided when working with inheritance. 

class Animal
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

class GoodDog < Animal
  def initialize(color)
    super
    @color = color
  end
end

bruno = GoodDog.new("brown")       
p bruno

On `line 118`, we assign `bruno` to an instance of the `GoodDog` class and have passed in the argument `brown`. The argument `brown` is then passed to the `initialize` method in the `GoodDog` class. Inside the `initialize` method in the `GoodDog` class, we call the `super` keyword which will find the method name of which it is called, up the method look up path. The next place in the method lookup path will be the superclass `Animal` from which `GoodDog` is inherited. Because `super` is not called with arguments, `super` will pass all arguments (which are passed to the method inside which it is called) to the method up the look up path. This means that `brown` will be passed to the `initialize` method in the `Animal` class thus assigning the instance variable `@name` to `brown`. The `initialize` method in `GoodDog` class will then continue on `line 114` and will assign `brown` to the instance variable `@color` as well. 

On `line 119`, we then call the `p` method on the object `bruno` which will output the object, an encoding of the object id as well as the instance variables `@name` and `@color` both assigned to the value `brown`. 

This demonstrates how `super` will search the method look up path for a method with the same name in which it is called. `super` will pass all arguments passed to the method in which it is called to the method further up the look up path. 

class Animal
  def initialize
  end
end

class Bear < Animal
  def initialize(color)
    super
    @color = color
  end
end

bear = Bear.new("black")   

On `line 139` we have assigned `bear` to an instance of the `Bear` class and passed in the argument `black`. This argument will be passed to the `initalize` method in the `Bear` class on `line 133`. Inside the `initalize` method on `line 134`, we have called the `super` keyword which will prompt Ruby to search the method look up path for a method with the same name as the method it has been called within. This means that Ruby will search the method look up path for an `initialize` method and will look in the `Animal` class next which is the superclass from which the `Bear` class subclasses from. The `super` keyword has not specified any arguments so all arguments passed to the method in which it is called, will be passed to the method up the look up path. The `initialize` method in the `Animal` class on `line 128` does not accept any arguments so passing the `black` argument will raise an error when we instantiate the `bear` object. 