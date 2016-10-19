require File.join(File.dirname(__FILE__), '..', 'cachet_api_gem')

Puppet::Type.type(:cachet_component_group).provide :api_gem, :parent => Puppet::Provider::CachetAPIGem do
  desc "API (Ruby Gem Client) provider for Cachet Component Group"
  
  mk_resource_methods
    
  def flush        
    if @property_flush[:ensure] == :absent
      deleteMe
      return
    end 
        
    if @property_flush[:ensure] != :absent
      return if createMe
    end
     
    updateMe
  end  

  def self.client
    api = get_api_info    
    CachetComponents.new(api[:api_key], api[:base_url])
  end
  
  def self.instances
    list = client.groups_list
    if list == nil
      raise "Could not call CachetComponents.groups_list"
    end   
    
    if list['data'] == nil
      return Array.new
    end
    
    result = Array.new  
    list['data'].each do |dataMap|
      objectMap = get(dataMap)
      if objectMap != nil
        #Puppet.debug "Component Group [Object] Found: "+objectMap.inspect
        result.push(new(objectMap))
      end
    end 
    result
  end
  
  def self.get(object)       
    #Puppet.debug "Component Group [Data] Found: "+object.inspect
    
    if object["name"] != nil 
      {
        :id        => object["id"],
        :name      => object["name"],  
        :order     => object["order"], 
        :collapsed => translateCollapsedToSymbol(object["collapsed"]), 
        :ensure    => :present
      }
    end
  end
    
  private
  def createMe
    if @property_hash.empty?  
      Puppet.debug "Create Component Group "+resource[:name]
        
      # Required parameters
      params = {         
        :name      => resource[:name],  
        :collapsed => self.class.translateCollapsedFromSymbol(resource[:collapsed]),
      }
          
      # Optional parameters     
      if resource[:order] != nil
        params[:order] = resource[:order]
      end
          
#      Puppet.debug "groups_create PARAMS = "+params.inspect
      response = self.class.client.groups_create(params)
      
      return true
    end
    
    false
  end

  def deleteMe
    Puppet.debug "Delete Component Group "+resource[:name]

    currentObject = lookupInstance(resource[:name])
    id = currentObject[:id]
      
    params = { 
      'id' => id,
    }
    #Puppet.debug "groups_delete PARAMS = "+params.inspect
    response = self.class.client.groups_delete(params)
  end

  def updateMe
    Puppet.debug "Update Component Group "+resource[:name]
                  
    currentObject = lookupInstance(resource[:name])
    id = currentObject[:id]
      
    params = {       
      'id'        => id,# Puppet links name to ID, so changing name is not possible !    
      'collapsed' => self.class.translateCollapsedFromSymbol(resource[:collapsed]),
    }
    
    # Optional parameters     
    if resource[:order] != nil
      params['order'] = resource[:order]
    end
      
    #Puppet.debug "groups_update PARAMS = "+params.inspect
    response = self.class.client.groups_update(params)
  end  
  
  def lookupInstance(name)
    list = self.class.client.groups_list
    if list == nil
      raise "Could not call CachetComponents.groups_list"
    end   
    
    if list['data'] == nil
      raise "No data present in CachetComponents.groups_list result"
    end
    
    list['data'].each do |dataMap|
      objectMap = self.class.get(dataMap)
      if objectMap != nil
        #Puppet.debug "Component Group [Object] Found: "+objectMap.inspect
        if objectMap[:name] == name
          #Puppet.debug "Component Group [Object] Matches: "+objectMap.inspect
          return objectMap
        end
      end
    end 
    
    raise "Could not find Component Group with name = "+name
  end
  
  def self.translateCollapsedFromSymbol(s)
    if s == :no
      return 0
    end
    if s == :yes
      return 1
    end 
    if s == :if_not_operational
      return 2
    end
  end
  
  def self.translateCollapsedToSymbol(n)
    if n == 0
      return :no
    end
    if n == 1
      return :yes
    end 
    if n == 2
      return :if_not_operational
    end
  end
end