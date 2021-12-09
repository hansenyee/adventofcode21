#!/usr/bin/env ruby
require_relative "libadvent.rb"
file = ARGF.readlines.map(&:chomp)
input = file.map { |l| l.chars.map(&:to_i) }

@xm = input.size
@ym = input.first.size

grid = (0...@xm).to_a.product((0...@ym).to_a)

@neighbors = [[-1,0], [1,0], [0,1], [0,-1]]

def addv(a,b)
  a.zip(b).map(&:sum)
end

min_c = grid.filter { |(x,y)|
  p = input[x][y]
  @neighbors.all? { |n|
    nx, ny = addv([x,y], n)
    next true unless (0...@xm).cover?(nx) && (0...@ym).cover?(ny)
    n = input[nx][ny]
    p < n
  }
}

points = min_c.map { |(x,y)| input[x][y] }
puts points.sum { |p| p+1 }

@pits = []
min_c = grid.filter { |(x,y)|
  p = input[x][y]
  ans = @neighbors.all? { |n|
    nx, ny = addv([x,y], n)
    next true unless (0...@xm).cover?(nx) && (0...@ym).cover?(ny)
    n = input[nx][ny]
    p < n
  }
  @pits << [x,y] if ans
  ans
}
@nines = grid.reduce([]) { |m,(x,y)| input[x][y] == 9 ? m+[[x,y]] : m }
raise "oops" unless @nines.size == input.flatten.count(9)

basins = @pits.map { |(px,py)|
  # crawl out of this pit, recording places seen, in each direction until finding a 9
  log = { [px,py] => input[px][py] }
  search = lambda { |x,y|
    here = input[x][y]
    log[[x,y]] = here
    @neighbors.each { |n|
      nx, ny = addv([x,y], n)
      next unless (0...@xm).cover?(nx) && (0...@ym).cover?(ny) # wall
      next if log[[nx,ny]] # seen this before
      n = input[nx][ny]
      next if 9 == n # basin boundary
      log[[nx,ny]] = n # record it
      search[nx,ny] # uhh
    }
  }
  search[px,py]
  log
}
puts basins.sort_by(&:size).reverse.first(3).map(&:size).reduce(&:*)
