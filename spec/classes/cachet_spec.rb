require 'spec_helper'

describe 'cachet' do
  context 'cachet on Ubuntu' do    
    let(:facts) {
      @ubuntu_facts
    }
    
    context 'cachet with minimal parameters on Ubuntu' do    
      let(:params) {{
        :application_key => 'Th1s1s@s3cr3t@ppl1c@t10nK3Y',
        :db_password     => 'tehcac',
        :admin_username  => 'lavaburn',
        :admin_password  => '$2y$10$T/Yz3ioTAVWLrpbXemPkveR8u0SzDjm9bvYSYSruzWvdNhPL8CrZC',
        :admin_email     => 'nicolas@rcswimax.com',
        :admin_api_key   => '1234567891234563789',
      }}
        
      it { should compile.with_all_deps }
  
      it { should contain_class('cachet::install') }
      it { should contain_class('cachet::config') }
      # TODO
    end
      
    describe "cachet with queue driver = database" do
      let(:params) {{
        :application_key => 'Th1s1s@s3cr3t@ppl1c@t10nK3Y',
        :db_password     => 'tehcac',
        :queue_driver    => 'database', 
        :admin_username  => 'lavaburn',
        :admin_password  => '$2y$10$T/Yz3ioTAVWLrpbXemPkveR8u0SzDjm9bvYSYSruzWvdNhPL8CrZC',
        :admin_email     => 'nicolas@rcswimax.com',
        :admin_api_key   => '1234567891234563789',
      }}
  
      it { should compile.with_all_deps }
        
      # TODO
    end
  end

  context 'cachet on CentOS' do    
    let(:facts) {
      @centos_facts
    }
    
    context 'cachet with minimal parameters' do    
      let(:params) {{
        :application_key => 'Th1s1s@s3cr3t@ppl1c@t10nK3Y',
        :db_password     => 'tehcac',
        :admin_username  => 'lavaburn',
        :admin_password  => '$2y$10$T/Yz3ioTAVWLrpbXemPkveR8u0SzDjm9bvYSYSruzWvdNhPL8CrZC',
        :admin_email     => 'nicolas@rcswimax.com',
        :admin_api_key   => '1234567891234563789',
      }}
        
      it { should compile.with_all_deps }
  
      it { should contain_class('cachet::install') }
      it { should contain_class('cachet::config') }
      # TODO
    end
  end
end
