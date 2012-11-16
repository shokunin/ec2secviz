require File.join(File.dirname(__FILE__), '..', "conf", "environment")
require 'sinatra'
require 'sinatra/base'
require 'sinatra/respond_to'
require 'json'

class Viz < Sinatra::Base
  register Sinatra::RespondTo
  set :public_folder, File.join(File.dirname(__FILE__) , '..' , '/static')
  set :views, File.join(File.dirname(__FILE__), '..', '/views')


  get '/graph_example' do
    respond_to do |wants|
      wants.html {  erb :graph_example,
      :layout => :base_layout }
    end
  end

  get '/open_ports_data/:hostname/list' do
    portslist = { "nodes" => [{"name" => params[:hostname], "group" => 1}], 
                  "links" => []
                }
    q=Secviz::Portsearch.new
    q.list_open_ports_by_host(params[:hostname]).each do |entry|
      portslist['nodes'] << {"name"=>entry,"group" => 1}
      portslist['links'] << {"source"=>portslist['nodes'].length-1,"target"=>0,"value"=>1+rand(100)}
    end
    portslist.to_json
  end

end
