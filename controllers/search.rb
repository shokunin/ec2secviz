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

#TODO: this is broken and I need to figure out why
  get '/hostinfo/info' do
    respond_to do |wants|
      wants.html {  erb :hostinfo,
        :layout => :base_layout }
      wants.json { "OK".to_json }
    end
  end

end
