#!/usr/bin/env ruby
require_relative "libadvent.rb"
file = ARGF.readlines
#file = ["16,1,2,0,4,2,7,1,2,14"] # example
input = file[0].split(",").map(&:to_i)

multiverse = input.map { |crab|
  input.map { |c| (crab - c).abs }
}
puts multiverse.min_by(&:sum).sum

# Part 2
def cost(n)
  (1..n).sum
end

min_crab, max_crab = input.minmax # somehow this doesn't cause trouble on p1

multiverse = (min_crab..max_crab).map { |crab|
  (input).map { |c|
    dist = (crab-c).abs
    cost(dist)
  }
}
puts multiverse.min_by(&:sum).sum
