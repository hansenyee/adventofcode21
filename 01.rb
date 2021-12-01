#!/usr/bin/env ruby
require_relative "libadvent.rb"
file = ARGF.readlines
input = file.map(&:to_i)

puts input.each_cons(2).count { |(a,b)| a < b }

puts input.each_cons(4).count { |(a,b,c,d)| 
  x = a+b+c
  y = b+c+d
  x < y
}
