#collect information about individial nodes
module Secviz
  require 'fog'
  require 'yaml'
  require 'secviz/config'
  require 'ostruct'
  class Nodes

    def cache_all_nodes
      node_cache = File.open(
        File.join(File.dirname(__FILE__), '..', '..', 'cache', 'node_cache.yml'),
        'w')
      node_cache.puts(self.get_all_nodes.to_yaml)
      node_cache.close
    end

    def cache_all_groups
      node_cache = File.open(
        File.join(File.dirname(__FILE__), '..', '..', 'cache', 'group_cache.yml'),
       'w')
      node_cache.puts(self.get_all_groups.to_yaml)
      node_cache.close
    end

    def get_all_nodes
      all_nodes = []
      accts = Secviz::Config.new
      accts.accounts.each do |acct|
        @@ZONES.each do |zone|
          config = accts.use_account(acct)
          config[:host] = "ec2.#{zone}.amazonaws.com"
          all_nodes += get_nodes(config, acct, zone)
        end
      end
      all_nodes
    end

    def get_all_groups
      all_groups = []
      accts = Secviz::Config.new
      accts.accounts.each do |acct|
        @@ZONES.each do |zone|
          config = accts.use_account(acct)
          config[:host] = "ec2.#{zone}.amazonaws.com"
          all_groups += get_groups(config, acct, zone)
        end
      end
      all_groups
    end

    def get_groups(config, account, zone)
      groups = []
      conn = Fog::Compute.new(config)
      conn.security_groups.all.each do |grp|
        groups << OpenStruct.new({
          :id             => grp.group_id,
          :account        => account,
          :zone           => zone,
          :name           => grp.name,
          :description    => grp.description,
          :ip_permissions => grp.ip_permissions,
        })
      end
      groups
    end


    def get_nodes(config, account, zone)
      nodes = []
      conn = Fog::Compute.new(config)
      conn.servers.all.each do |srv| 

          if srv.tags.has_key?"Name"
            srv_name = srv.tags["Name"]
          else
            srv_name = srv.private_dns_name
          end

        nodes <<  OpenStruct.new({ 
          :id                 => srv.id,
          :account            => account,
          :zone               => zone,
          :private_ip_address => srv.private_ip_address,
          :private_ip_address => srv.private_ip_address,
          :public_ip_address  => srv.public_ip_address,
          :security_group_ids => srv.security_group_ids,
          :name               => srv_name,
        })

      end
      nodes
    end

  end
end
