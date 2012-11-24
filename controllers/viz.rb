require File.join(File.dirname(__FILE__), '..', "conf", "environment")
require 'sinatra'
require 'sinatra/base'
require 'sinatra/respond_to'
require 'json'

class Viz < Sinatra::Base
  register Sinatra::RespondTo
  set :public_folder, File.join(File.dirname(__FILE__) , '..' , '/static')
  set :views, File.join(File.dirname(__FILE__), '..', '/views')


  get '/:hostname/graph' do
    respond_to do |wants|
      wants.html {  erb :graph_example,
        :locals => { :hostname => params[:hostname]},
        :layout => :base_layout }
    end
  end

  get '/open_ports_data/:hostname/list' do
    q=Secviz::Portsearch.new
    q.ports2d3(params[:hostname]).to_json
  end

end
