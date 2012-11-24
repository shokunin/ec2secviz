#collect information about individial nodes
module Secviz
  class Portsearch
    require 'yaml'
    require 'ostruct'

    def list_open_ports_by_host(hostname)
      open_conns = {}
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
              elsif y['fromPort'].to_i == 0 and  y['toPort'].to_i == 65535
                ports = "all"
              else
                ports = "#{y['fromPort']}-#{y['toPort']}"
              end
              if open_conns.has_key? "#{ports}/#{y['ipProtocol']}"
                y['groups'].each { |g| open_conns["#{ports}/#{y['ipProtocol']}"] << "#{g['groupName']}" }
              else
                open_conns["#{ports}/#{y['ipProtocol']}"] = y['groups'].collect{ |x| x["groupName"] }
              end

              y['ipRanges'].each do |g| 
                if g['cidrIp'] =~ /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\/32$/
                  bloc = $1
                elsif g['cidrIp'] =~ /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\/0$/
                  bloc = "Internet"
                else
                  bloc = g['cidrIp']
                end
                if open_conns.has_key? "#{ports}/#{y['ipProtocol']}"
                  open_conns["#{ports}/#{y['ipProtocol']}"] << bloc
                else
                  open_conns["#{ports}/#{y['ipProtocol']}"] = [ bloc ]
                end
              end
            end
          end
        end
      end
      open_conns
    end

    def ports2d3(hostname)
      portslist = { "nodes" => [{"name" => hostname, "group" => 3}], 
                  "links" => []
                }
      self.list_open_ports_by_host(hostname).each do |port, hosts|
        portslist["nodes"] << {"name" => port, "group" => 1}
        port_in_nodes = portslist["nodes"].length - 1
        portslist["links"] << {"source" => port_in_nodes, "target"=>0, "value"=>1}
        hosts.each do |host| 
          portslist["nodes"] << {"name" => host, "group" => 2}
          host_in_nodes = portslist["nodes"].length - 1
          portslist["links"] << {"source" => host_in_nodes, 
                                 "target" => port_in_nodes, 
                                 "value"=>1}
        end
      end
      portslist
    end
  end
end
