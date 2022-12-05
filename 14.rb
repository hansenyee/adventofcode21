#!/usr/bin/env ruby
require_relative 'libadvent'
file = ARGF.readlines
template = file.first.chomp

RULES = file[2..-1].map { _1.scan(/(.{2}) -> (.)/).first }.map { |(k, v)| [k.chars, v] }.to_h

class Polymer
  def initialize template
    @state = Hash.new(0).merge(template.chars.each_cons(2).tally)
    @elements = Hash.new(0).merge(template.chars.tally)
    @steps = 0
  end

  def step!
    @state = next_polymer
    @steps += 1
  end

  def next_polymer
    result = @state.dup
    RULES.each do |cons, splice|
      count = @state[cons]
      next unless count > 0

      l, r = cons
      # an embarrasing amount of time was spent here
      result[[l, splice]] += count
      result[[splice, r]] += count
      result[cons] -= count
      @elements[splice] += count
    end
    result.delete_if { |_, v| v == 0 }
    return result
  end

  def ans
    @elements.values.minmax.reverse.reduce(:-)
  end

  def size
    @elements.values.sum
  end
end

Polymer.new(template).then do |polymer|
  10.times { polymer.step! }
  puts polymer.ans
  30.times { polymer.step! }
  puts polymer.ans
end
