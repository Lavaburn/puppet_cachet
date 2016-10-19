# Custom Type: Cachet - Component

Puppet::Type.newtype(:cachet_component) do
  @doc = "Cachet Component"

  ensurable do
    defaultvalues
    defaultto :present
  end
  
  newparam(:name, :namevar => true) do
    desc "The component name"
  end

  # This field should never be managed by Puppet !!! 
#  newproperty(:status) do
#    desc "Component Status"
#  end
  
  # Optional
  newproperty(:description) do
    desc "The component description"    
  end

  newproperty(:link) do
    desc "Hyperlink to the component"
  end

  newproperty(:order) do
    desc "Order Number"
  end

  newproperty(:group_name) do
    desc "The group name this component belongs to"
  end
  
  newproperty(:enabled) do
    desc "Whether the component is enabled"
    newvalues(true, false)
  end
  
  # Not supported by API Client?
#  newproperty(:component_tags, :array_matching => :all) do
#    desc "Tags for the component"
#  end
end