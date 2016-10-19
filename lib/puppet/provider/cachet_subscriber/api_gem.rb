require File.join(File.dirname(__FILE__), '..', 'cachet_api_gem')

Puppet::Type.type(:cachet_subscriber).provide :api_gem, :parent => Puppet::Provider::CachetAPIGem do
  desc "API (Ruby Gem Client) provider for Cachet Subscriber"
  
  mk_resource_methods
    
  def flush        
    if @property_flush[:ensure] == :absent
      deleteMe
      return
    end 
        
    if @property_flush[:ensure] != :absent
      return if createMe
    end
     
    raise "Subscriber does not have any update functionality"
  end  

  def self.client
    api = get_api_info    
    CachetSubscribers.new(api[:api_key], api[:base_url])
  end
  
  def self.instances
    list = client.list
    if list == nil
      raise "Could not call CachetSubscribers.list"
    end   
    
    if list['data'] == nil
      return Array.new
    end
    
    result = Array.new  
    list['data'].each do |dataMap|
      objectMap = get(dataMap)
      if objectMap != nil
        #Puppet.debug "Subscriber [Object] Found: "+objectMap.inspect
        result.push(new(objectMap))
      end
    end 
    result
  end
  
  def self.get(object)       
    #Puppet.debug "Subscriber [Data] Found: "+object.inspect
    
    if object["email"] != nil 
      {
        :id     => object["id"],
        :name   => object["email"],  
        :email  => object["email"],  
        :ensure => :present
      }
    end
  end
    
  private
  def createMe
    if @property_hash.empty?  
      Puppet.debug "Create Subscriber "+resource[:email]
        
      # Required parameters
      params = {         
        :email  => resource[:email],
        :verify => true,
      }
                
      #Puppet.debug "create PARAMS = "+params.inspect
      response = self.class.client.create(params)
      
      return true
    end
    
    false
  end

  def deleteMe
    Puppet.debug "Delete Subscriber "+resource[:email]

    currentObject = lookupInstance(resource[:email])
    id = currentObject[:id]
      
    params = { 
      'id' => id,
    }
    #Puppet.debug "delete PARAMS = "+params.inspect
    response = self.class.client.delete(params)
  end
  
  def lookupInstance(email)
    list = self.class.client.list
    if list == nil
      raise "Could not call CachetSubscribers.list"
    end   
    
    if list['data'] == nil
      raise "No data present in CachetSubscribers.list result"
    end
    
    list['data'].each do |dataMap|
      objectMap = self.class.get(dataMap)
      if objectMap != nil
        #Puppet.debug "Subscriber [Object] Found: "+objectMap.inspect
        if objectMap[:email] == email
          #Puppet.debug "Subscriber [Object] Matches: "+objectMap.inspect
          return objectMap
        end
      end
    end 
    
    raise "Could not find Subscriber with email = "+email
  end
end