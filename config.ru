# controllers to load
require (File.join(File.dirname(__FILE__), 'controllers', 'downloader'))
require (File.join(File.dirname(__FILE__), 'controllers', 'toppage'))

# serve up static assets using rack
map "/js" do
  run Rack::Directory.new("#{File.join(File.dirname(__FILE__), 'static', 'js')}")
end

map "/download" do
    run Downloader
end

map "/" do
    run Toppage
end
