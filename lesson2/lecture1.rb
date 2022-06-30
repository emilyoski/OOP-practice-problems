class Person
  attr_accessor :first_name, :last_name
  
  def initialize(first_name, last_name = '')
    @first_name = first_name
    @last_name = last_name
  end

  def name
    if (@last_name == '') || (@last_name == nil)
      @first_name
    else
      @first_name + ' ' + @last_name
    end
  end

  def name=(name)
    names = name.split
    @first_name = names[0]
    @last_name = names[1]
  end
end

bob = Person.new('Robert Smith')
rob = Person.new('Robert Smith')

puts bob.object_id
puts rob.object_id

puts bob.name == rob.name