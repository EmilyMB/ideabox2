$:.unshift File.expand_path("./../lib", __FILE__)
require 'bundler'
require 'app'

Bundler.require

run IdeaBoxApp
