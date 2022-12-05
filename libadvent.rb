class Array
  # all combinations
  def combinations
    (1..size).map { |n| combination(n) }.flatten
  end

  def frequency
    # mode and (what is the least frequent called?)
    min, max = tally.minmax_by { |(_, v)| v }.map(&:first)
    { most: max, least: min }
  end
end

class String
  # bits to integer
  def to_i2
    to_i(2)
  end

  def sort
    chars.sort.join
  end
end

class Integer
  # integer to bits
  def to_bin
    format('%b', self)
  end

  def to_hex
    format('%x', self)
  end
end

class Hash
  def self.new_of_arrays(*array_init)
    new { |h, k| h[k] = Array.new(*array_init) }
  end
end

module Advent
  module_function

  def commas(io)
    io.read.split(',')
  end
end
