require 'sinatra/respond_to'
require 'secviz'
require 'json'

class Search < Sinatra::Base
  register Sinatra::RespondTo
  set :public_folder, File.dirname(__FILE__) + '..', '/static'
  set :views, File.join(File.dirname(__FILE__), '..', '/views')

  get '/allbyname' do
    q=Secviz::Cache.new
    q.search_nodes({}, ['name']).collect.each{ |k| p k['name'] }.sort.to_json
  end


end
