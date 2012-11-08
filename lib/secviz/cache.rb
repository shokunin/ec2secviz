#collect information about individial nodes
module Secviz
  class Cache
    require 'yaml'

    def load_nodes
      YAML::load(File.open("/tmp/node_cache.yml"))
    end

    def load_groups
      YAML::load(File.open("/tmp/group_cache.yml"))
    end

#TODO allow groups to be searchable
    def search_groups
      nodes = self.load_groups
    end

#TODO allow nodes to be searchable
    def search_nodes
      nodes = self.load_nodes
    end

  end
end
