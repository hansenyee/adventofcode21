#!/usr/bin/env ruby
require_relative "libadvent.rb"
file = ARGF.readlines
#file = ["acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"]
input = file.map { |l| l.split("|").map { |m| m.split.map { |n| n.chars.sort } } }
input.each { |(s,o)| s.sort_by!(&:size) }

p1 = input.map { |(sigs,o)| 
  res = {}
  res[1] = sigs[0]
  res[4] = sigs[2]
  res[7] = sigs[1] 
  res[8] = sigs[9]
  res
}

puts p1.zip(input).flat_map { |r,(s,o)|
  v = r.values
  o.count { |output| v.include?(output) }
}.sum

# P2
# canon = %w(abcefg cf acdeg acdfg bcdf abdfg abdefg acf abcdefg abcdfg).map.with_index { |w,i| [i, w.chars.sort] }.to_h

p2 = input.zip(p1).map { |(sigs,out),p1|
  diff = lambda { |*is| is.map { |i| p1[i] }.reduce(&:-) } # :-)
  usum = lambda { |*ns| ns.map { |i| sigs[i] }.sum([]) }
  
  n = {}.merge(p1)
  # 1 4 7 8 known
  # 5-size 2 3 5
  # 6-size 0 6 9
  # seg = {}
  a = diff[7,1]
  adg = usum[3,4,5].tally.select { |k,v| v == 3 }.map(&:first)
  dg = adg - a
  g = dg - p1[4]
  d = dg - g
  cf = p1[1]
  
  n[3] = (d + g + n[7]).uniq.sort
  # known 1 3 4 7 8
  n[9] = (n[3] + n[4] + g).uniq.sort
  e = n[9] - n[8]
  n[0] = n[8] - d
  # known 0 1 3 4 7 8 9
  b = n[9] - n[1] - adg
  # have a b d g e
  # don't have c f (1)
  # unknown 2 5 6
  u256 = sigs - n.values
  # 2 = the one not containing b
  # 6 = the long one
  n[2] = u256.find { |ary| !ary.include?(b[0]) }
  n[6] = u256.max_by(&:size)
  # 5 = whatever is left
  n[5] = u256.find { |a| a != n[2] && a != n[5] }
  chr_to_i = n.map { |k,v| [v.join, k.to_s] }.to_h
  out.map { |o| chr_to_i[o.join] }.join.to_i
} # (o_O);
puts p2.sum
