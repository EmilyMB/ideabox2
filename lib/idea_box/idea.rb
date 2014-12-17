require 'yaml/store'

class Idea
  include Comparable

  attr_reader :title, :description, :rank, :id, :tags

  def initialize(attributes)
    @title = attributes["title"]
    @description = attributes["description"]
    @rank = attributes["rank"] || 0
    @id = attributes["id"]
    if attributes["tags"].is_a? String
      @tags = attributes["tags"].split(/[,.]/).map{|tag| tag.strip}.sort
    else
      @tags = [""]
    end
    @time = Time.now()
  end

  def <=>(other)
    other.rank <=> rank
  end

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
      "rank" => rank,
      "tags" => tags,
      "id" => id,
      "time" => time
    }
  end
end
