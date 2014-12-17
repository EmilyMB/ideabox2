require 'yaml/store'

class IdeaStore

  def self.raw_ideas
    raw_ideas = database.transaction do |db|
      db['ideas'] || []
    end
  end

  def self.all
    ideas = []
    raw_ideas.each_with_index do |data, i|
      ideas << Idea.new(data.merge("id" => i))
    end
    ideas
  end

  def self.database
    return @database if @database

    @database = YAML::Store.new('db/ideabox')
    @database.transaction do
      @database['ideas'] ||= []
    end
    @database
  end

  def self.delete(position)
    database.transaction do
      database['ideas'].delete_at(position)
    end
  end

  def self.find_raw_idea(id)
    database.transaction do
      database['ideas'].find{|idea| idea["id"] == id}
    end
  end

  def self.find(id)
    raw_idea = find_raw_idea(id)
    Idea.new(raw_idea.merge("id" => id))
  end

  def self.update(id, data)
    database.transaction do
      database['ideas']["id"] = data
    end
  end

  def self.create(attributes)
    database.transaction do
      database['ideas'] << attributes
    end
  end

  def self.find_raw_ideas_by_tag(tag)
    database.transaction do
      # require 'pry'
      # binding.pry
      raw_ideas = database['ideas'].map do |idea|
        idea if idea["tags"].include?(tag)
      end
    end
    raw_ideas
  end

  def self.find_by_tag(tag)
    raw_ideas = find_raw_ideas_by_tag(tag)
    ideas = raw_ideas.map do |idea|
      Idea.new(idea)
    end
    ideas
  end
end
