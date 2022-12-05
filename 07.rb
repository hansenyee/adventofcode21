#!/usr/bin/env ruby
require_relative "libadvent.rb"
file = ARGF.read
#file = "16,1,2,0,4,2,7,1,2,14" # example
input = file.split(",").map(&:to_i)

multiverse = input.map { |crab|
  input.map { |c| (crab - c).abs }
}
puts multiverse.map(&:sum).min

# Part 2
def cost(n)
  (1..n).sum
end

min_crab, max_crab = input.minmax # somehow this doesn't cause trouble on p1
multiverse = (min_crab..max_crab).map { |crab|
  input.map { |c| cost((crab - c).abs) }
}
puts multiverse.map(&:sum).min
