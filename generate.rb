#!/usr/bin/env ruby
exit unless ARGV[0]

number = ARGV[0]
fname = number + ".rb"

unless File.exist?(fname)
  File.open(fname, "w") { |f|
    f.write <<RUBY
#!/usr/bin/env ruby
require_relative "libadvent.rb"
file = ARGF.readlines
input = file

RUBY
    f.chmod(0744) # u+x
  }
end

