class Vehicle
  attr_accessor :year, :color, :model
  @@number_of_cars = 0
  
  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @speed = 0
    @@number_of_cars += 1
  end
  
  def to_s
    "Your vehicle is a #{year} #{color} #{model}."
  end

  def self.how_many_cars
    @@number_of_cars
  end

  def spray_paint(color)
    self.color = color
  end

  def show_age
    "The vehicle is #{determine_age} years old."
  end

  private

  def determine_age
    Time.now.year - year
  end
end

module Drivable
  def self.calculate_gas_mileage(gas_used, distance_traveled)
    @gas_mileage = distance_traveled / gas_used
  end

  def increase_speed(speed_increase)
    @speed = @speed + speed_increase
  end

  def brake(speed_decrease)
    @speed = @speed - speed_decrease
  end

  def shut_off
    @speed = 0
  end

  def speed
    "You are driving at #{@speed} mph."
  end
end

class MyCar < Vehicle
  include Drivable
  CAR_SEATS = 4
end

class MyTruck < Vehicle
  CAR_SEATS = 2
end

Toyota = MyCar.new(2012, "Grey", "Camry")
Ford = MyTruck.new(2021, "Black", "F150")

Toyota.spray_paint("Blue")
puts Toyota.show_age