class Transportation
  attr_reader :make, :model

  def initialize(make, model)
    @make = make
    @model = model
  end

  def to_s
    "#{make} #{model}"
  end
end

class Car < Transportation
  def wheels
    4
  end
end

class Motorcycle < Transportation
  def wheels
    2
  end
end

class Truck < Transportation
  attr_reader :payload

  def initialize(make, model, payload)
    super(make, model)
    @payload = payload
  end

  def wheels
    6
  end
end