begin
  require 'cachet' if Puppet.features.cachet_api?
rescue LoadError => e
  Puppet.info "Cachet Puppet module requires 'cachet_api' ruby gems." # or 'rest-client'
end

class Puppet::Provider::CachetAPIGem < Puppet::Provider
  desc "Cachet API (Ruby Gem Client) calls"
  
  confine :feature => :cachet_api

  def initialize(value={})
    super(value)
    @property_flush = {} 
  end
    
  def self.get_api_info
    config_file = "/etc/cachet/api.yaml"

    data = File.read(config_file) or raise "Could not read setting file #{config_file}"    
    yamldata = YAML.load(data)
    
    if yamldata.include?('base_url')
      base_url = yamldata['base_url']
    else
      raise "The configuration file #{config_file} should include an entry 'base_url'"
    end

    if yamldata.include?('api_key')
      api_key = yamldata['api_key']
    else
      raise "The configuration file #{config_file} should include an entry 'api_key'"
    end
    
    { 
      :base_url => base_url,
      :api_key  => api_key,
    }
  end
  
  def exists?    
    @property_hash[:ensure] == :present
  end
  
  def create
    @property_flush[:ensure] = :present
  end

  def destroy        
    @property_flush[:ensure] = :absent
  end
          
  def self.prefetch(resources)        
    instances.each do |prov|
      if resource = resources[prov.name]
        resource.provider = prov
      end
    end
  end  
end