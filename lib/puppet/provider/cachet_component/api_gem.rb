require File.join(File.dirname(__FILE__), '..', 'cachet_api_gem')

Puppet::Type.type(:cachet_component).provide :api_gem, :parent => Puppet::Provider::CachetAPIGem do
  desc "API (Ruby Gem Client) provider for Cachet Component"
  
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
    list = client.list
    if list == nil
      raise "Could not call CachetComponents.list"
    end   
    
    if list['data'] == nil
      return Array.new
    end
    
    result = Array.new  
    list['data'].each do |dataMap|
      objectMap = get(dataMap)
      if objectMap != nil
        #Puppet.debug "Component [Object] Found: "+objectMap.inspect
        result.push(new(objectMap))
      end
    end 
    result
  end
  
  def self.get(object)       
    #Puppet.debug "Component [Data] Found: "+object.inspect
    
    if object["name"] != nil 
      {
        :id             => object["id"],
        :name           => object["name"],  
        :description    => object["description"],  
        :link           => object["link"],  
        :status         => object["status"],  
        :order          => object["order"], 
        :group_name     => getGroupName(object["group_id"]),
        :enabled        => object["enabled"], 
        :component_tags => object["tags"],    
        :ensure         => :present
      }
    end
  end
    
  private
  def createMe
    if @property_hash.empty?  
      Puppet.debug "Create Component "+resource[:name]
        
      # Required parameters
      params = {         
        :name   => resource[:name], 
        :status => 1, 
      }
          
      # Optional parameters     
      if resource[:description] != nil
        params[:description] = resource[:description]
      end
      
      if resource[:link] != nil
        params[:link] = resource[:link]
      end
      
      if resource[:order] != nil
        params[:order] = resource[:order]
      end
      
      if resource[:group_name] != nil
        params[:group_id] = self.class.getGroupId(resource[:group_name])
      end
      
      if resource[:enabled] != nil
        params[:enabled] = resource[:enabled]
      end
                
      #Puppet.debug "create PARAMS = "+params.inspect
      response = self.class.client.create(params)
      
      return true
    end
    
    false
  end

  def deleteMe
    Puppet.debug "Delete Component "+resource[:name]

    currentObject = lookupInstance(resource[:name])
    id = currentObject[:id]

    params = { 
     'id' => id,
    }
    #Puppet.debug "delete PARAMS = "+params.inspect
    response = self.class.client.delete(params)
  end

  def updateMe
    Puppet.debug "Update Component "+resource[:name]
                  
    currentObject = lookupInstance(resource[:name])
    id = currentObject[:id]
      
    params = {       
      'id'        => id,# Puppet links name to ID, so changing name is not possible !    
    }
    
    # Optional parameters     
    if resource[:description] != nil
      params['description'] = resource[:description]
    end    
    
    if resource[:link] != nil
      params['link'] = resource[:link]
    end    
    
    if resource[:order] != nil
      params['order'] = resource[:order]
    end    
    
    if resource[:group_name] != nil
      params['group_id'] = self.class.getGroupId(resource[:group_name])
    end    
    
    if resource[:enabled] != nil
      params['enabled'] = resource[:enabled]
    end    
      
    #Puppet.debug "update PARAMS = "+params.inspect
    response = self.class.client.update(params)
  end  
  
  def lookupInstance(name)
    list = self.class.client.list
    if list == nil
      raise "Could not call CachetComponents.list"
    end   
    
    if list['data'] == nil
      raise "No data present in CachetComponents.list result"
    end
    
    list['data'].each do |dataMap|
      objectMap = self.class.get(dataMap)
      if objectMap != nil
        #Puppet.debug "Component [Object] Found: "+objectMap.inspect
        if objectMap[:name] == name
          #Puppet.debug "Component [Object] Matches: "+objectMap.inspect
          return objectMap
        end
      end
    end 
    
    raise "Could not find Component with name = "+name
  end
  
  def self.getGroupName(id)
    #Puppet.debug "getGroupName Called - ID = #{id.inspect}"    
    if id == 0
      return "" # Unmanaged / Not set ?
    end
      
    group = client.groups_list_id({ 'id' => id})
    #Puppet.debug "groups_list_id RESULT = "+group.inspect
    if group == nil || group["data"] == nil
      raise "Could not find Component Group with ID = #{id}"
    end

    return group["data"]["name"]
  end
  
  def self.getGroupId(name)
    Puppet.info "getGroupId Called - NAME = #{name.inspect}"    
    groups = client.groups_list
    
    if groups == nil || groups['data'] == nil
      raise "Could not find any Component Groups"
    end
    
    groups['data'].each do |group|
      Puppet.info "groups_list RESULT ITEM = "+group.inspect
      if group['name'] == name
        return group['id']
      end    
    end
    
    return 0
  end
end