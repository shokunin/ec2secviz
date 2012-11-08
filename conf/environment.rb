#!/usr/bin/env ruby

require 'yaml'

begin
  @@ec2conf = YAML::load(File.open(File.join(File.dirname(__FILE__), "ec2_credentials.yml")))
rescue Exception => e
  puts "Could not load config file: #{e.message}"
  exit! 1
end

$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "lib")

@@ZONES = ['us-west-1', 'us-east-1', 'eu-west-1']

