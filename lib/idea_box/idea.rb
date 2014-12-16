require 'yaml/store'

class Idea
  include Comparable

  attr_reader :title, :description, :rank, :id

  def initialize(attributes)
    @title = attributes["title"]
    @description = attributes["description"]
    @rank = attributes["rank"] || 0
    @id = attributes["id"]
  end

  def <=>(other)
    other.rank <=> rank
  end
  # def self.raw_ideas
  #   raw_ideas = database.transaction do |db|
  #     db['ideas'] || []
  #   end
  # end
  #
  # def self.all
  #   raw_ideas.map do |data|
  #     Idea.new(data)
  #   end
  # end
  #
  # def self.database
  #   @database ||= YAML::Store.new('ideabox')
  # end
  #
  # def self.delete(position)
  #   database.transaction do
  #     database['ideas'].delete_at(position)
  #   end
  # end
  #
  # def self.find_raw_idea(id)
  #   database.transaction do
  #     database['ideas'].at(id.to_i)
  #   end
  # end
  #
  # def self.find(id)
  #   Idea.new(find_raw_idea(id))
  # end
  #
  # def self.update(id, data)
  #   database.transaction do
  #     database['ideas'][id] = data
  #   end
  # end

  def like!
    @rank += 1
  end

  def save
    IdeaStore.create(to_h)
  end

  def to_h
    {
      "title" => title,
      "description" => description,
      "rank" => rank
    }
  end
end
