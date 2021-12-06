#!/usr/bin/env ruby
require_relative "libadvent.rb"
file = ARGF.readlines
#file = ["3,4,3,1,2"] # example
input = file.first.split(",").map(&:to_i)

def run_step(fish)
  new_fish_count = 0
  next_fish = fish.map { |f| 
    if f == 0
      new_fish_count += 1
      6
    else
      f - 1
    end
  }
  return next_fish + ([8] * new_fish_count)
end

fish80 = 80.times.reduce(input) { |m,_| run_step(m) }
puts fish80.size

census = Hash.new(0).merge(input.tally)
def part2(fish)
  next_fish = fish.dup
  fish.each { |k,v|
    if k == 0
      # spawn fishies
      next_fish[6] += v
      next_fish[8] += v
      next_fish[0] -= v
    else
      next_fish[k] -= v
      next_fish[k-1] += v
    end
  }.to_h
  return next_fish
end

fish256 = 256.times.reduce(census) { |m,_| part2(m) }
puts fish256.values.sum
