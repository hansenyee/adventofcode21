#!/usr/bin/env ruby
require_relative "libadvent.rb"
file = ARGF.readlines
input = file.map(&:chomp).map(&:chars)

scores = [
  [")",3],
  ["]",57],
  ["}",1197],
  [">",25137]
].to_h

def digest chars
  close = ")]}>".chars
  opens = close.zip("([{<".chars).to_h

  errors = 0
  s = []
  corrupted_char = nil
  chars.each { |c|
    if close.include?(c) # this is a closer 
      v = s.last
      if v == opens[c] # this closer matches. pop
        s.pop
      else
        #puts "error!"
        #puts "valid close was #{s.last}"
        errors += 1
        break corrupted_char = c
        next s.pop
      end
    else # this is an opener. push it.
      s << c
    end
  }
  corrupted_char
end

p1 = input.map { |cs| digest(cs) }.compact.map { |c| scores[c] }.sum
puts p1

incomplete = input.map { |cs| digest(cs) }.zip(input).select { |(c,_)| c.nil? }.map(&:last)

def d2 chars
  close = ")]}>".chars
  opens = close.zip("([{<".chars).to_h

  s = []
  chars.each { |c|
    if close.include?(c)
      v = s.last
      if v == opens[c] # this closer matches. pop
        s.pop
      else
        puts "oops"
        #binding.irb
      end
    else # this is an opener. push it.
      s << c
    end
  }
  s.reverse.join.tr("([{<", ")]}>").chars
end

sco = [[")",1], ["]",2], ["}",3], [">", 4]].to_h

i = incomplete.map { |s|
  d2(s).reduce(0) { |m,c|
    m * 5 + sco[c]
  }
}.sort
puts i[i.size/2]
