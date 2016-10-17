require 'spec_helper_acceptance'

describe 'cachet class' do
	describe 'default install' do
  	it 'should work idempotently with no errors' do
  		pp = <<-EOS
    		class { 'cachet': 
          application_key => 'Th1s1s@s3cr3t@ppl1c@t10nK3Y',
          db_password     => 'tehcac',
          admin_username  => 'lavaburn',
          admin_password  => '$2y$10$T/Yz3ioTAVWLrpbXemPkveR8u0SzDjm9bvYSYSruzWvdNhPL8CrZC',
          admin_email     => 'nicolas@rcswimax.com',
          admin_api_key   => '1234567891234563789',
    		}      		
  		EOS

  		# First Install
  		apply_manifest(pp, :catch_failures => true)
  		
  		# Allow concat to store proper template of config file
  		apply_manifest(pp, :catch_failures => true)
  		
  		# No more changes allowed
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
  	end

#      describe service('freeradius') do
#        it { should be_running }
#      end
  	
    describe port(8001) do
      it { should be_listening }
    end
  end
  
  describe 'redis cache and supervisor queue' do
    it 'should reconfigure' do
      pp = <<-EOS
        class { 'cachet': 
          application_key => 'Th1s1s@s3cr3t@ppl1c@t10nK3Y',
          db_password     => 'tehcac',
          smtp_hostname   => 'smtp.rcswimax.com',
          smtp_username   => 'cachet',
          smtp_password   => 'techac',
          smtp_address    => 'cachet@rcswimax.com',
          smtp_name       => 'Cachet HQ',
          admin_username  => 'lavaburn',
          admin_password  => '$2y$10$T/Yz3ioTAVWLrpbXemPkveR8u0SzDjm9bvYSYSruzWvdNhPL8CrZC',
          admin_email     => 'nicolas@rcswimax.com',
          admin_api_key   => '1234567891234563789',          
          queue_driver    => 'redis',
          cache_driver    => 'redis',
          session_driver  => 'redis',
          queue_worker    => 'supervisor',
        }         
      EOS

      # First Install
      apply_manifest(pp, :catch_failures => true)

      # No more changes allowed
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end
      
#      describe service('freeradius') do
#        it { should be_running }
#      end
  end
end