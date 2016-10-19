# Custom Type: Cachet - Component Group

Puppet::Type.newtype(:cachet_component_group) do
  @doc = "Cachet Component Group"

  ensurable do
    defaultvalues
    defaultto :present
  end
  
  newparam(:name, :namevar => true) do
    desc "The component group name"
  end

  newproperty(:collapsed) do
    desc "Whether the component group should show as collapsed"
    defaultto :no
    newvalues(:no, :yes, :if_not_operational)
  end
  
  # Optional
  newproperty(:order) do
    desc "Order Number"
  end
end