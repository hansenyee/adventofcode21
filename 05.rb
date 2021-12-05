#!/usr/bin/env ruby
require_relative "libadvent.rb"
file = ARGF.readlines
input = file.map { |line|
  c = line.split
  from = c[0].split(",").map(&:to_i)
  to = c[2].split(",").map(&:to_i)
  [from, to]
}

# Part 1
map = Hash.new(0)
input.each { |(f,t)|
  same_x = f[0] == t[0]
  same_y = f[1] == t[1]
  if same_x # Y line
    x = f[0]
    y1, y2 = [f[1], t[1]].minmax
    (y1..y2).each { |y| map["#{x},#{y}"] += 1 }
  else # X line
  next unless same_y
    y = f[1]
    x1, x2 = [f[0], t[0]].minmax
    (x1..x2).each { |x| map["#{x},#{y}"] += 1 }
  end
}
puts map.values.count { |c| c > 1 }

# Part 2
map = Hash.new(0)
input.each { |(f,t)|
  same_x = f[0] == t[0]
  same_y = f[1] == t[1]
  if same_x # Y line
    x = f[0]
    y1, y2 = [f[1], t[1]].minmax
    (y1..y2).each { |y| map["#{x},#{y}"] += 1 }
  elsif same_y # X line
    y = f[1]
    x1, x2 = [f[0], t[0]].minmax
    (x1..x2).each { |x| map["#{x},#{y}"] += 1 }
  else # 45 line
    x1, x2 = f[0], t[0]
    y1, y2 = f[1], t[1]
    if x1 < x2
      y = y1
      dy = y2 > y1 ? 1 : -1
      (x1..x2).each { |x|
        map["#{x},#{y}"] += 1
        y += dy
      }
    else
      y = y2
      dy = y1 > y2 ? 1 : -1
      (x2..x1).each { |x|
        map["#{x},#{y}"] += 1
        y += dy
      }
    end
  end
}
puts map.values.count { |c| c > 1 }
