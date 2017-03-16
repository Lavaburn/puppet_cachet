require 'beaker-rspec'

hosts.each do |host|
  # Using box with pre-installed Puppet !
end

RSpec.configure do |c|
	# Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  fixtures_dir = File.expand_path(File.join(proj_root, '/spec/fixtures'))
  
	# Readable test descriptions
	c.formatter = :documentation

	# Configure all nodes in nodeset
  c.before :suite do    
    # Puppet Modules from PuppetForge
    hosts.each do |host|
      if fact('operatingsystem') == 'Ubuntu'
        if fact('operatingsystemrelease') == '14.04'
          on host, 'apt-key adv --keyserver keyserver.ubuntu.com --recv-keys --recv-keys 7F438280EF8D349F'
        end    
        
        on host, 'apt-get update'   
        on host, 'apt-get install augeas-lenses'        
      end      
      
      on host, puppet('module','install','puppet/php'),           { :acceptable_exit_codes => [0,1] } 
      on host, puppet('module','install','thomasvandoren/redis'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs/mysql'),     { :acceptable_exit_codes => [0,1] }        
      on host, puppet('module','install','puppetlabs/apache'),    { :acceptable_exit_codes => [0,1] }    
      on host, puppet('module','install','puppetlabs/vcsrepo'),   { :acceptable_exit_codes => [0,1] }   
      on host, puppet('module','install','puppetlabs/git'),       { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','ajcrowe/supervisord'),  { :acceptable_exit_codes => [0,1] }     
         
      # Auto Dependencies
      # on host, puppet('module','install','puppetlabs/concat'),    { :acceptable_exit_codes => [0,1] }
      # on host, puppet('module','install','puppetlabs/stdlib'),    { :acceptable_exit_codes => [0,1] }

      # Install this module
      install_dev_puppet_module_on(host, {
        :source             => proj_root, 
        :target_module_path => '/etc/puppetlabs/code/modules/',
        :module_name        => 'cachet'
      })  
    end
  end  
end
