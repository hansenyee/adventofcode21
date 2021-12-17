#!/usr/bin/env ruby
require_relative "libadvent.rb"
file = ARGF.readlines
input = file.map { |l| l.chomp.split("-") }

@map = Hash.new_of_arrays
input.each_with_object(@map) { |(f,t),m| m[f] << t; m[t] << f } # both directions connected

def big? s
  s =~ /[A-Z]/
end

@p = Set.new
def search path
  @p << path
  @map[path.last].each { |p| !path.include?(p) || big?(p) ?  search(path+[p]) : path }
end
search(["start"])
puts @p.count { |p| p[-1] == "end"}

def small_ok?(path)
  return false if path.count("start") > 1 || path.count("end") > 1
  count = (path - ["start","end"]).reject { big?(_1) }.tally
  count_count = count.values.tally
  return false if count_count[3] # any small cave appears more than twice
  c = count_count[2]
  return (c.nil? || c == 1) # 0 or 1 small cave appears twice
end
# this is definitely not fast
def search2 path
  return unless small_ok?(path)
  @p << path
  @map[path.last].each { |n| search2(path+[n]) }
end
@p = Set.new
search2(["start"])
q = @p.select { _1.last == "end" }.sort_by(&:size)
puts q.size

__END__
start-A
start-b
A-c
A-b
b-d
A-end
b-end
