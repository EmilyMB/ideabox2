$:.unshift File.expand_path("./../lib", __FILE__)
$:.unshift File.expand_path("./../db", __FILE__)
puts "this is file expanded path #{File.expand_path("./../db", __FILE__)}"
require 'bundler'
require 'app'
require 'idea_box'

Bundler.require

run IdeaBoxApp
