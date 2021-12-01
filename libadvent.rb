require "set"
class Array
  def combinations # all combinations
    (1..size).map { |n| combination(n) }.flatten
  end
end

class String
  def to_i2 # bits to integer
    to_i(2)
  end
end

class Integer
  def to_bin # integer to bits
    sprintf("%b", self)
  end
  def to_hex
    sprintf("%x", self)
  end
end

class Hash
  def self.new_of_arrays(*array_init)
    self.new { |h,k| h[k] = Array.new(*array_init) }
  end
end

class RingList # See 2020 #23
  attr_reader :size

  Node = Struct.new(:data, :next) {
    def to_a
      [data] + self.next.to_a
    end
  }

  def initialize(list, index: false)
    @size = list.size
    @head = Node.new(list[0])
    @index = {}
    @index[list[0]] = @head if index
    curr = @head
    list[1..-1].each { |i|
      curr.next = Node.new(i)
      curr = curr.next
      @index[i] = current if index
    }
    curr.next = @head
  end

  def inspect
    "#<#{self.class} head pointing #{@head.data}>"
  end

  def to_a
    res = Array.new(@size)
    current = @head
    res.each_index { |i|
      res[i] = current.data
      current = current.next
    }
  end

  def rotate
    @head = @head.next
    return @head.data
  end

  def curr
    @head.data
  end
end # RingList
