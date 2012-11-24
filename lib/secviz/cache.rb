#collect information about individial nodes
module Secviz
  class Cache
    require 'yaml'
    require 'ostruct'

    def load_nodes
      YAML::load(File.open(
        File.join(File.dirname(__FILE__), '..', '..', 'cache', 'node_cache.yml'))
      )
    end

    def load_groups
      YAML::load(File.open(
        File.join(File.dirname(__FILE__), '..', '..', 'cache', 'group_cache.yml'))
      )
    end

    def search_groups_by_id(id)
      matches = []
      self.load_groups.each do |group|
        if group.id == id
          matches << group.marshal_dump
        end
      end
      matches
    end

    def ip_search(ip_address)
      res = self.search_nodes({"public_ip_address" => ip_address}, ['name'] )
      if res.length == 0
        name = ip_address
      else
        name = res[0]["name"]
      end
      name
    end

    def search_nodes(params={}, resp={})
      matches = []
      self.load_nodes.each do |node|
        m = 0
        params.each do |k, v|
          if node.send(k) == v
            m += 1
          end
        end
        if m >= params.length
          if resp.length < 1
            matches << node.marshal_dump
          else
            q = {}
            resp.each{|v| q[v] = node.send(v)}
            matches << q
          end
        end
      end
      matches
    end

  end
end
