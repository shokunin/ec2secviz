require File.join(File.dirname(__FILE__), '..', "conf", "environment")
require 'sinatra'
require 'sinatra/base'
require 'sinatra/respond_to'

class Toppage < Sinatra::Base
  register Sinatra::RespondTo
  set :public_folder, File.join(File.dirname(__FILE__) , '..' , '/static')
  set :views, File.join(File.dirname(__FILE__), '..', '/views')

  #just respond with OK, so that monitoring knows that the application is running
  get '/monitor' do
    "OK"
  end

  get '/' do
    respond_to do |wants|
      wants.html {  erb :index,
      :layout => :base_layout }
    end
  end

  get '/hostinfo' do
    respond_to do |wants|
      wants.html {  erb :host_form,
      :layout => :base_layout }
    end
  end

end
