require 'yaml/store'

class IdeaStore

  def self.raw_ideas
    raw_ideas = database.transaction do |db|
      db['ideas'] || []
    end
  end

  def self.all
    ideas = raw_ideas.map do |data|
      Idea.new(data)
    end
    ideas
  end

  # def self.sort_by_tag
  #   database.sort_by{|hsh| hsh["tags"][0]}
  # end


  def self.database
    return @database if @database
    if ENV["RACK_ENV"] =="test"
      @database = YAML::Store.new('db/testbox')
      @database.transaction do
        @database['ideas'] ||= []
      end
    else
      @database = YAML::Store.new('db/ideabox')
      @database.transaction do
        @database['ideas'] ||= []
      end
    end
    @database
  end

  def self.delete(id)
    database.transaction do
      database['ideas'].delete_if{|idea| idea["id"] == id}
    end
  end

  def self.find_raw_idea(id)
    database.transaction do
      database['ideas'].find{|idea| idea["id"] == id}
    end
  end

  def self.find(id)
    raw_idea = find_raw_idea(id)
    Idea.new(raw_idea)
  end

  def self.update(id, data)
    database.transaction do
      position = database['ideas'].index{|idea| idea["id"] == id}
      data["id"] = id
      data["tags"] = database['ideas'][position]["tags"]
      database['ideas'][position] = data
    end
  end

  def self.create(attributes)
    database.transaction do
      max_id = @database['ideas'].size + 1
      attributes["id"] = max_id
      attributes["time"] ||= Time.now()
      database['ideas'] << attributes
    end
  end

  def self.find_raw_ideas_by_tag(tag)
    selected_ideas = []
    database.transaction do
    #   raw_ideas = database['ideas'].map do |idea|
    #     idea if idea["tags"].include?("fruit")
    #   end
    # end
    #
      database['ideas'].each do |idea|
        if idea["tags"].include?(tag)
          selected_ideas << idea
        end
      end
    end
    selected_ideas
  end

  def self.find_by_tag(tag)
    selected_ideas = find_raw_ideas_by_tag(tag)
    ideas = selected_ideas.map do |idea|
      Idea.new(idea)
    end
    ideas
  end
end
