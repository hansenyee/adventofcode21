#!/usr/bin/env ruby
require_relative "libadvent.rb"
file = ARGF.readlines.map(&:chomp)

class Bingo < Array
  @@winners = []
  attr_reader :marks

  def self.reset_winners
    @@winners = []
  end

  def self.winners
    @@winners
  end

  def initialize(*a)
    @marks = []
    super(*a)
  end

  def mark(n)
    @marks << n
    check_board
  end

  def check_board
    cond = lambda { |b|
      b.any? { |ary|
        ary.count { |n| @marks.member?(n) } == 5
      }
    }

    res = cond[self] || cond[transpose]
    @@winners << self if res && !@@winners.member?(self)
    res
  end

  def unmarked_nums
    flatten - @marks.to_a
  end

  def reset!
    @marks = []
  end
end

@number_list = file.first.split(",").map(&:to_i)
boards = file[2..-1].each_slice(6).map { |sli| # trailing line
  sli[0..4] }.map { |strings| strings.map { |s| s.split.map(&:to_i) } }.map { |aa| Bingo.new(aa) }

def run_bingo(boards)
  @number_list.each { |n|
    @winner = boards.find { |b| b.mark n }
    return n if @winner
  }
end

def run_bingo_loser(boards)
  @number_list.each { |n|
    boards.each { |b| b.mark n }
    if Bingo.winners.size == boards.size # got last winner
      @loser = Bingo.winners.last
      return n
    end
  }
end

last_num = run_bingo(boards)
puts @winner.unmarked_nums.sum * last_num

Bingo.reset_winners
boards.each(&:reset!)
last_num = run_bingo_loser(boards)
puts @loser.unmarked_nums.sum * last_num
