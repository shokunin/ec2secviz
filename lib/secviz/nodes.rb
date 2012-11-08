#collect information about individial nodes
module Secviz
  require 'fog'
  require 'yaml'
  require 'secviz/config'
  class Nodes

    def cache_all_nodes
      node_cache = File.open('/tmp/node_cache.yml', 'w')
      node_cache.puts(self.get_all_nodes.to_yaml)
      node_cache.close
    end

    def cache_all_groups
      node_cache = File.open('/tmp/group_cache.yml', 'w')
      node_cache.puts(self.get_all_groups.to_yaml)
      node_cache.close
    end

    def get_all_nodes
      all_nodes = {}
      accts = Secviz::Config.new
      accts.accounts.each do |acct|
        all_nodes[acct] = {}
        @@ZONES.each do |zone|
          config = accts.use_account(acct)
          config[:host] = "ec2.#{zone}.amazonaws.com"
          all_nodes[acct][zone] = get_nodes(config)
        end
      end
      all_nodes
    end

    def get_all_groups
      all_groups = {}
      accts = Secviz::Config.new
      accts.accounts.each do |acct|
        all_groups[acct] = {}
        @@ZONES.each do |zone|
          config = accts.use_account(acct)
          config[:host] = "ec2.#{zone}.amazonaws.com"
          all_groups[acct][zone] = get_groups(config)
        end
      end
      all_groups
    end

    def get_groups(config)
      groups = []
      conn = Fog::Compute.new(config)
      conn.security_groups.all.each do |grp|
        groups << {
          :id             => grp.group_id,
          :name           => grp.name,
          :description    => grp.description,
          :ip_permissions => grp.ip_permissions,
        }
      end
      groups
    end


    def get_nodes(config)
      nodes = []
      conn = Fog::Compute.new(config)
      conn.servers.all.each do |srv| 

          if srv.tags.has_key?"Name"
            srv_name = srv.tags["Name"]
          else
            srv_name = srv.private_dns_name
          end

        nodes << { 
          :id                 => srv.id,
          :private_ip_address => srv.private_ip_address,
          :private_ip_address => srv.private_ip_address,
          :public_ip_address  => srv.public_ip_address,
          :security_group_ids => srv.security_group_ids,
          :name               => srv_name,
        }

      end
      nodes
    end

  end
end
