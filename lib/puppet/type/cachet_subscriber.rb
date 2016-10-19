# Custom Type: Cachet - Subscriber

Puppet::Type.newtype(:cachet_subscriber) do
  @doc = "Cachet Subscriber"

  ensurable do
    defaultvalues
    defaultto :present
  end
  
  newparam(:email, :namevar => true) do
    desc "The subscriber email"
  end

  # Only used on creation. No need to keep track of it.
#  newparam(:verify) do
#    desc "Whether to verify the address"
#  end
end