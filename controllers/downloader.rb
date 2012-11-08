require File.join(File.dirname(__FILE__), '..', "conf", "environment")
require 'sinatra'
require 'sinatra/base'
require 'sinatra/respond_to'
require 'secviz'

class Downloader < Sinatra::Base
  register Sinatra::RespondTo
  set :public_folder, File.dirname(__FILE__) + '..', '/static'
  set :views, File.join(File.dirname(__FILE__), '..', '/views')

  get '/cache_nodes' do
    q=Secviz::Nodes.new
    q.cache_all_nodes
    "CACHED_ALL_NODES"
  end

  get '/cache_groups' do
    q=Secviz::Nodes.new
    q.cache_all_groups
    "CACHED_ALL_GROUPS"
  end


end
