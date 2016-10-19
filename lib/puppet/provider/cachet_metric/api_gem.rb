require File.join(File.dirname(__FILE__), '..', 'cachet_api_gem')

Puppet::Type.type(:cachet_metric).provide :api_gem, :parent => Puppet::Provider::CachetAPIGem do
  desc "API (Ruby Gem Client) provider for Cachet Metric"
  
  mk_resource_methods
    
  def flush        
    if @property_flush[:ensure] == :absent
      deleteMe
      return
    end 
        
    if @property_flush[:ensure] != :absent
      return if createMe
    end
     
    raise "API does not support updating metric!"
  end  

  def self.client
    api = get_api_info    
    CachetMetrics.new(api[:api_key], api[:base_url])
  end
  
  def self.instances
    list = client.list
    if list == nil
      raise "Could not call CachetMetrics.list"
    end   
    
    if list['data'] == nil
      return Array.new
    end
    
    result = Array.new  
    list['data'].each do |dataMap|
      objectMap = get(dataMap)
      if objectMap != nil
        #Puppet.debug "Metric [Object] Found: "+objectMap.inspect
        result.push(new(objectMap))
      end
    end 
    result
  end
  
  def self.get(object)       
    #Puppet.debug "Metric [Data] Found: "+object.inspect
    
    if object["display_chart"] != nil and object["display_chart"]
      display_chart = :true
    else
      display_chart = :false
    end
    
    if object["name"] != nil 
      {
        :id            => object["id"],
        :name          => object["name"],          
        :suffix        => object["suffix"],  
        :description   => object["description"],  
        :default_value => object["default_value"],  
        :display_chart => display_chart,
        :ensure        => :present
      }
    end
  end
    
  private
  def createMe
    if @property_hash.empty?  
      Puppet.debug "Create Metric "+resource[:name]
        
      # Required parameters
      params = {         
        :name          => resource[:name], 
        :suffix        => resource[:suffix], 
        :description   => resource[:description], 
        :default_value => resource[:default_value], 
        :display_chart => (resource[:display_chart]?1:0), 
      }
                
      #Puppet.debug "create PARAMS = "+params.inspect
      response = self.class.client.create(params)
      
      return true
    end
    
    false
  end

  def deleteMe
    Puppet.debug "Delete Metric "+resource[:name]

    currentObject = lookupInstance(resource[:name])
    id = currentObject[:id]

    params = { 
     'id' => id,
    }
    #Puppet.debug "delete PARAMS = "+params.inspect
    response = self.class.client.delete(params)
  end

  def lookupInstance(name)
    list = self.class.client.list
    if list == nil
      raise "Could not call CachetMetrics.list"
    end   
    
    if list['data'] == nil
      raise "No data present in CachetMetrics.list result"
    end
    
    list['data'].each do |dataMap|
      objectMap = self.class.get(dataMap)
      if objectMap != nil
        #Puppet.debug "Metric [Object] Found: "+objectMap.inspect
        if objectMap[:name] == name
          #Puppet.debug "Metric [Object] Matches: "+objectMap.inspect
          return objectMap
        end
      end
    end 
    
    raise "Could not find Metric with name = "+name
  end
end