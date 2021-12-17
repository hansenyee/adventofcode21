#!/usr/bin/env ruby
require_relative "libadvent.rb"
f_dots, f_folds = ARGF.read.split("\n\n")

dots = f_dots.split("\n").map { _1.split(",").map(&:to_i) }
folds = f_folds.split("\n").map {
  axis, amt = _1.scan(/fold along ([xy])=(\d+)/)
}.map(&:first)

xm = dots.map(&:first).max
ym = dots.map(&:last).max
@width = xm+1

def to_i s
  s.tr(".#","01").to_i2
end

def to_dots i, w=@width
  i.to_bin.rjust(w, ".").tr("01",".#")
end

def show grid
  puts grid.map(&:join)
end

def reverse i
  i.to_bin.rjust(@width, "0").reverse.to_i2
end

def hfold(grid, y)
  top = grid[0...y]
  bot = grid[y+1..-1]
  # line y is discarded
  top = top.transpose.map { to_i(_1.join) }
  bot = bot.transpose.map { to_i(_1.reverse.join) }
  merged = top.zip(bot).map { |(a,b)| a | b }
  return merged.map { to_dots(_1, y).chars }.transpose
end

def vfold(grid, x)
  grid = rotate_right(grid)
  grid = hfold(grid,x) # :)
  return rotate_left(grid)
end

def rotate_right a
  a.reverse.transpose
end

def rotate_left a
  a.transpose.reverse
end

grid_map = dots.group_by(&:first).map { |(gx,group)|
  row = group.map(&:last).reduce(Array.new(ym+1)) { |m,i| m[i] = true; m }
  [gx, row]
}.to_h
grid_map
grid = (0..xm).map { |xi| grid_map[xi] || Array.new(ym+1) }.transpose.map { |a| a.map { |b| b ? "#" : "." } }
xm, ym = ym, xm # switch to puzzle coords

step = lambda { |g,(axis,amount)|
  amount = amount.to_i
  case axis
  when "x"
    vfold(g,amount)
  when "y"
    hfold(g,amount)
  else
    puts "oops: axis not understood"
    binding.irb
    raise
  end
}

p1 = step[grid,folds.first]

def count g
  g.flatten.count("#")
end

puts count p1

p2 = folds.reduce(grid, &step)
show p2
puts
puts p2.map { _1.join.tr("."," ") }
