require 'bundler'
require 'idea_box'
Bundler.require


class IdeaBoxApp < Sinatra::Base
  set :method_override, true
  set :root, 'lib/app'

  register Sinatra::Partial
  set :partial_template_engine, :erb

  configure :development do
    register Sinatra::Reloader
  end

  not_found do
    erb :error
  end

  get '/' do
    erb :index, locals: {ideas: IdeaStore.all.sort, idea:Idea.new(params)}
  end

  post '/' do
    IdeaStore.create(params[:idea])
    redirect '/'
  end

  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect '/'
  end

  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :edit, locals: {idea: idea}
  end

  put '/:id' do |id|
    IdeaStore.update(id.to_i, params[:idea])
    redirect '/'
  end

  post '/:id/like' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end

  post '/sort' do
    erb :index, locals: {ideas: IdeaStore.all.sort_by{|hsh| hsh.tags[0].nil? ? "zzz" : hsh.tags[0]}, idea:Idea.new(params)}
  end

  post '/sort_by_tag' do
     erb :index, locals: {ideas: IdeaStore.find_by_tag(params[:tag]), idea:Idea.new(params)}
  end

  post '/weekday' do
    erb :weekday, locals: {ideas: IdeaStore.all.sort, idea:Idea.new(params)}
  end

  post '/hours' do
    erb :hours, locals: {ideas: IdeaStore.all.sort, idea:Idea.new(params)}
  end
end
