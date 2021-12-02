#!/usr/bin/env ruby
require_relative "libadvent.rb"
file = ARGF.readlines
input = file.map { |line| line.split }

depth = 0
range = 0

input.each { |(command, qty)|
  qty = qty.to_i
  case command
  when "down"
    range += qty
  when "up"
    range -= qty
  when "forward"
    depth += qty
  else
    puts "wut"
    binding.irb
  end
}

puts depth * range

depth = 0
range = 0
aim   = 0

input.each { |(command, qty)|
  qty = qty.to_i
  case command
  when "down"
    aim += qty
  when "up"
    aim -= qty
  when "forward"
    range += qty
    depth += qty * aim
  else
    puts "wut"
    binding.irb
  end
}

puts depth * range
