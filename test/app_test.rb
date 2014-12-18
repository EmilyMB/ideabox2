ENV["RACK_ENV"] = "test"

require 'bundler'
Bundler.require :default, :test
$:.unshift File.expand_path("../../lib", __FILE__)
require_relative '../lib/app.rb'

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    IdeaBoxApp.new
  end

  def test_it_returns_a_200
    get '/'
    assert last_response.ok?
  end

  def test_it_creates_something
    IdeaStore.create(
    {"title" => "a",
    "description" => "asd",
    "rank" => "7",
    "tags" => "red",
    "id" => "19"})
    get '/'
    html = Nokogiri::HTML(last_response.body)
    assert last_response.ok?
  end
end
