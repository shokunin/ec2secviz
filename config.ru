# controllers to load
require (File.join(File.dirname(__FILE__), 'controllers', 'downloader'))
require (File.join(File.dirname(__FILE__), 'controllers', 'toppage'))
require (File.join(File.dirname(__FILE__), 'controllers', 'search'))
require (File.join(File.dirname(__FILE__), 'controllers', 'viz'))

# serve up static assets using rack
map "/js" do
  run Rack::Directory.new("#{File.join(File.dirname(__FILE__), 'static', 'js')}")
end

map "/download" do
    run Downloader
end

map "/search" do
    run Search
end

map "/viz" do
    run Viz
end

map "/" do
    run Toppage
end
