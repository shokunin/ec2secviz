#collect information about individial nodes
module Secviz
  class Portsearch
    require 'yaml'
    require 'ostruct'
    require 'pp'

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
                  bloc = cache.ip_search($1)
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

    def node2pos(nodes={}, name)
      pos = -1
      val = -1
      nodes.each do |x|
        pos += 1
        if x['group'] == 2 and x['name'] == name
          val = pos
        end
      end
      val
    end

    def ports2d3(hostname, port_filter=[])
      portslist = { "nodes" => [{"name" => hostname, "group" => 3}], 
                  "links" => []
                }
      self.list_open_ports_by_host(hostname).each do |port, hosts|
        if port_filter.length == 0 or port_filter.member?port
          portslist["nodes"] << {"name" => port, "group" => 1}
          port_in_nodes = portslist["nodes"].length - 1
          portslist["links"] << {"source" => port_in_nodes, "target"=>0, "value"=>1}
          hosts.each do |host| 
            #check to see if we already have the node in the list of nodes
            have_node = node2pos(portslist['nodes'], host)
            if have_node > -1
              host_in_nodes = have_node
            else
              portslist["nodes"] << {"name" => host, "group" => 2}
              host_in_nodes = portslist["nodes"].length - 1
            end
            portslist["links"] << {"source" => host_in_nodes, 
                                   "target" => port_in_nodes, 
                                   "value"=>1}
          end
        end
      end
      portslist
    end
  end
end
