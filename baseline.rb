#!/usr/bin/env ruby

# For each file in ARGV:
# Find associated .baseline file or default.baseline
# Add points (x,y) to fit class
# Build splines
# Output

require "commander/import"
require "tempfile"
require "shellwords"

%w|baseline gnuplot output_formatter point knot region|.each do |s|
  require_relative "lib/#{s}"
end

Dir["#{__dir__}/lib/plugins/*.rb"].each{ |f| require_relative f }

program :name, "Baseline"
program :version, "Like you care"
program :description, "Bases lines"

