require 'spec_helper_acceptance'

describe 'cachet api' do    
	describe 'component groups' do
    #before { skip("Works!") }	  
	  
  	it 'should create idempotently without errors' do
  		pp = <<-EOS
  		  cachet_component_group { 'new_group': }  		    
  		  
  		EOS

  		# First Install
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to eq(2)
  		
  		# No more changes allowed
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
  	end
  	
    it 'should update idempotently without errors' do
      pp = <<-EOS
        cachet_component_group { 'new_group': 
          order     => 10,
          collapsed => 'if_not_operational',
        }
      EOS

      # First Install
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to eq(2)
      
      # No more changes allowed
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end
        
    it 'should delete idempotently without errors' do
      pp = <<-EOS
        cachet_component_group { 'new_group': 
          ensure => 'absent',
        }
      EOS
  
      # First Install
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to eq(2)
      
      # No more changes allowed
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end
	end
	
	describe 'components' do
    #before { skip("Works!") }   
      
    it 'should set up dependent group' do
      pp = <<-EOS   
        cachet_component_group { 'puppet_test1': }
      EOS
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to eq(2)
    end    
      
    it 'should create idempotently without errors' do
      pp = <<-EOS
        cachet_component { 'new_item': 
          
        }
        cachet_component { 'new_item1': 
          description => 'This is a test (1)',
          group_name  => 'puppet_test1', 
        }
      EOS
  
      # First Install
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to eq(2)
      
      # No more changes allowed
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end
    
    it 'should update idempotently without errors' do
      pp = <<-EOS
        cachet_component { 'new_item': 
          description => 'This is a test',
          order       => 20,
          group_name  => 'puppet_test1',
        }
      EOS
  
      # First Install
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to eq(2)
      
      # No more changes allowed
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end
        
    it 'should delete idempotently without errors' do
      pp = <<-EOS
        cachet_component { 'new_item': 
          ensure => 'absent',
        }
        cachet_component { 'new_item1': 
          ensure => 'absent',
        }
      EOS
  
      # First Install
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to eq(2)
      
      # No more changes allowed
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end
       
    it 'should destroy dependent group' do
      pp = <<-EOS   
        cachet_component_group { 'puppet_test1': 
          ensure => 'absent',
        }
      EOS
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to eq(2)
    end
  end
  
  describe 'subscribers' do
    #before { skip("Works!") }   
    
    it 'should create idempotently without errors' do
      pp = <<-EOS
        cachet_subscriber { 'nicolas@rcswimax.com': 
        
        }
      EOS
  
      # First Install
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to eq(2)
      
      # No more changes allowed
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end
    
    it 'should delete idempotently without errors' do
      pp = <<-EOS
        cachet_subscriber { 'nicolas@rcswimax.com': 
          ensure => 'absent',
        }
      EOS
  
      # First Install
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to eq(2)
      
      # No more changes allowed
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end
  end

  describe 'metrics' do
    #before { skip("Works!") }   
    
    it 'should create idempotently without errors' do
      pp = <<-EOS
        cachet_metric { 'test_metric1': 
          suffix        => 'tests',
          description   => 'This is a test metric',
        }
      EOS
  
      # First Install
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to eq(2)
      
      # No more changes allowed
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end
    
    it 'should delete idempotently without errors' do
      pp = <<-EOS
      cachet_metric { 'test_metric1': 
          ensure => 'absent',
        }
      EOS
  
      # First Install
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to eq(2)
      
      # No more changes allowed
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end
  end
end