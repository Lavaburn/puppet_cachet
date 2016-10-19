# Custom Type: Cachet - Metric

Puppet::Type.newtype(:cachet_metric) do
  @doc = "Cachet Metric"

  ensurable do
    defaultvalues
    defaultto :present
  end
  
  newparam(:name, :namevar => true) do
    desc "The metric name"
  end
  
  newproperty(:suffix) do
    desc "Unit of the metric"
  end
  
  newproperty(:description) do
    desc "Description of the metric"
  end
  
  newproperty(:default_value) do
    desc "Default metric value"
    defaultto 0
  end
  
  newproperty(:display_chart) do
    desc "Whether to display a chart of the metrics on the dashboard"
    defaultto true
    newvalues(true, false)
  end
end