require 'sinatra/respond_to'
require 'secviz'
require 'json'

class Search < Sinatra::Base
  register Sinatra::RespondTo
  set :public_folder, File.dirname(__FILE__) + '..', '/static'
  set :views, File.join(File.dirname(__FILE__), '..', '/views')

  get '/allbyname' do
    q=Secviz::Cache.new
    q.search_nodes({}, ['name']).collect.each{ |k| k['name'] }.sort.to_json
  end

  get '/hostinfo/:hostname/info' do
    q=Secviz::Cache.new
    host_info = q.search_nodes({:name => params[:hostname]})
    host_info.each do |host|
      host[:security_groups] = []
      host[:security_group_ids].each do |group| 
        q.search_groups_by_id(group).each { |x|  host[:security_groups] <<  x[:name]}
      end
      host.delete(:security_group_ids)
    end
    respond_to do |wants|
      wants.html {   erb :hostinfo,
        :layout => :base_layout, 
        :locals => {:host_info => host_info }
      }
    end
  end


end
