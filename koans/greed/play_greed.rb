#!/usr/bin/env ruby
require File.expand_path(File.dirname(__FILE__) + "/lib/greed")

if ARGV.empty?
  STDOUT.puts <<-EOF
Please provide player names

Usage:
  play_greed [NAMES]
EOF
  abort
end

Greed::Game.start_game(*ARGV)
