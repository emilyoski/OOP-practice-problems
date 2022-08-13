class CircularQueue
  attr_accessor :queue

  def initialize(elements)
    @queue = []
    elements.times { |_| @queue << nil }
  end

  def enqueue(element)
    if queue.include?(nil)
      index = queue.index(nil)
      queue[index] = element
    else
      next_queue = queue[1..-1] + [element]
      self.queue = next_queue
    end
  end

  def dequeue
    element = queue[0]
    next_queue = queue[1..-1] + [nil]
    self.queue = next_queue
    element
  end

  def show_queue
    queue
  end
end

queue = CircularQueue.new(3)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil

queue = CircularQueue.new(4)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 4
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil