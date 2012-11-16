#collect information about individial nodes
module Secviz
  class Portsearch
    require 'yaml'
    require 'ostruct'

    def list_open_ports_by_host(hostname)
      open_conns = []
      cache = Secviz::Cache.new
      host_info = cache.search_nodes({:name => hostname})
      host_info.each do |host|
        host[:security_group_ids].each do |group|
          cache.search_groups_by_id(group).each do |x|
            x[:ip_permissions].each do |y|
              if y['fromPort'] == -1 
                ports = "all"
              elsif y['fromPort'] == y['toPort']
                ports = y['fromPort']
              else
                ports = "#{y['fromPort']}-#{y['toPort']}"
              end
              y['groups'].each { |g| open_conns << "#{g['groupName']} #{ports}/#{y['ipProtocol']}" }
              y['ipRanges'].each do |g| 
                if g['cidrIp'] =~ /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\/32$/
                  bloc = $1
                elsif g['cidrIp'] =~ /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\/0$/
                  bloc = "Internet"
                else
                  bloc = g['cidrIp']
                end
                open_conns << "#{bloc} #{ports}/#{y['ipProtocol']}" 
              end
            end
          end
        end
      end
      open_conns
    end
  end
end
