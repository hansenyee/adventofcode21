#!/usr/bin/env ruby
require_relative "libadvent.rb"
file = ARGF.readlines
input = file.map(&:chomp).map(&:chars)

digest = input.transpose.map(&:frequency)

gamma = digest.map { |m| m[:most] }.join.to_i2
epsilon = digest.map { |m| m[:least] }.join.to_i2
puts gamma * epsilon

@width = input.first.size
def search(list, index, search_type)
  f = list.map { |l| l[index] }.frequency
  max = f[:most]
  min = f[:least]

  if max == min # eq case
    crit = search_type
  else
    crit = (search_type == "1" ? max : min)
  end

  next_list = list.select { |l| l[index] == crit }

  return next_list if next_list.size <= 1
  raise "oops" if index > @width or next_list.size == 0
  return search(next_list, index+1, search_type)
end

oxy = search(input,0,"1").first.join.to_i2
coo = search(input,0,"0").first.join.to_i2
puts oxy * coo
