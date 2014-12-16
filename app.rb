require 'bundler'
require './idea'
Bundler.require


class IdeaBoxApp < Sinatra::Base
  set :method_override, true

  configure :development do
    register Sinatra::Reloader
  end

  not_found do
    erb :error
  end

  get '/' do
    erb :index, locals: {ideas: Idea.all}
  end

  post '/' do
    idea = Idea.new(params[:idea])
    idea.save
    redirect '/'
  end

  delete '/:id' do |id|
    Idea.delete(id.to_i)
    redirect '/'
  end

  get '/:id/edit' do |id|
    idea = Idea.find(id)
    erb :edit, locals: {id: id, idea: idea}
  end

  put '/:id' do |id|
    # data = {
    #   :title => params['idea_title'],
    #   :description => params['idea_description']
    # }
    Idea.update(id.to_i, params[:idea])
    redirect '/'
  end
end
