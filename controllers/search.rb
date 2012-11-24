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

  get '/hostinfo/:hostname/info' do
    q=Secviz::Cache.new
    hostinfo = q.search_nodes({ "name" => params[:hostname] }, {} )
    respond_to do |wants|
      wants.html {  erb :hostinfo,
        :locals => {:host_info => hostinfo, :hostname => params[:hostname]},
        :layout => :base_layout }
      wants.json { hostinfo.to_json }
    end
  end

end
