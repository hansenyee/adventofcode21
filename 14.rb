#!/usr/bin/env ruby
require_relative "libadvent.rb"
file = ARGF.readlines
template = file.first.chomp

@ins = file[2..-1].map { _1.scan(/(.{2}) -> (.)/).first }.map { |(k,v)| [k.chars,v] }.to_h

def polymerize(poly)
  pairs = poly.chars.each_cons(2).to_a
  pairs.map { |p|
    if(i = @ins[p])
      res = p.dup
      res.insert(1,i)
      res
    else
      p
    end
  }.map { _1[0..-2] }.flatten.join + poly[-1]
end

p1 = 10.times.reduce(template) { |m,_| polymerize m }

def count poly
  min, max = poly.chars.tally.values.minmax
  max - min
end

puts count p1
