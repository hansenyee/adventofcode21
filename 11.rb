#!/usr/bin/env ruby
require_relative "libadvent.rb"
file = ARGF.readlines
input = file.map { _1.chomp.chars.map(&:to_i) }

class Grid < Array
  def initialize(*a)
    super(*a)
    @max_x = size
    @max_y = first.size
    @grid = (0...@max_x).to_a.product((0...@max_y).to_a)
  end

  def neighbors(a) # todo: extend to arb dimensions
    n = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]] 
    n.map { |b| a.zip(b).map(&:sum) }.select { |(x,y)|
      (0...@max_x).cover?(x) && (0...@max_y).cover?(y)
    }
  end
end

class Dumbo < Grid
  attr_reader :flash_count, :steps
  def initialize(*a)
    super(*a)
    @flash_count = 0
    @steps = 0
  end

  def step
    @flashed = Set.new
    @grid.each { |(cx,cy)| increment(cx,cy) }
    @flashed.each { |(fx,fy)| self[fx][fy] = 0 }
    @flash_count += @flashed.size
    @steps += 1
  end

  def step2
    @flashed = Set.new
    @grid.each { |(cx,cy)| increment(cx,cy) }
    @flashed.each { |(fx,fy)| self[fx][fy] = 0 }
    @steps += 1
    @flashed.size
  end

  def flash(x,y)
    return if @flashed.member?([x,y])
    @flashed.add([x,y])
    neighbors([x,y]).each { |(nx,ny)| increment(nx,ny) }
  end

  def increment(x,y)
    value = self[x][y]
    flash(x,y) if value >= 9
    self[x][y] += 1
  end

  def show
    puts map(&:join)
  end
end

p1 = Dumbo.new(input.map(&:dup))
100.times { p1.step }
puts p1.flash_count

p2 = Dumbo.new(input.map(&:dup))
size = p2.size * p2.first.size
loop {
  value = p2.step2
  if size == value || p2.steps > 1000
    puts p2.steps
    break
  end
}
