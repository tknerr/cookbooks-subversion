require File.expand_path('../helpers', __FILE__)

describe 'subversion::client' do
    
  %w{ redhat centos fedora ubuntu debian }.each do |platform|
    
    context "on platform #{platform}" do
      let (:chef_run) {
        mock_ohai_and_converge(platform: platform)
      }

      it 'should install the "subversion" package' do
        chef_run.should install_package 'subversion'
      end
    end
  
  end

  context 'on ubuntu, version < 8.04' do
    let (:chef_run) { 
      mock_ohai_and_converge(platform: 'ubuntu', platform_version: '7.10')
    }

    it 'should install the proper extra packages' do 
      chef_run.should install_package "subversion-tools"
      chef_run.should install_package "libsvn-core-perl"
    end
  end

  context 'on ubuntu, version >= 8.04' do
    let (:chef_run) { 
      mock_ohai_and_converge(platform: 'ubuntu', platform_version: '8.04')
    }

    it 'should install the proper extra packages' do 
      chef_run.should install_package "subversion-tools"
      chef_run.should install_package "libsvn-perl"
    end
  end

  context 'on centos, redhat or fedora' do
    let (:chef_run) { 
      mock_ohai_and_converge(platform: 'redhat')
    }

    it 'should install the proper extra packages' do 
      chef_run.should install_package "subversion-devel"
      chef_run.should install_package "subversion-perl"
    end
  end



  def mock_ohai_and_converge(attrs = {})
    mock_ohai(attrs)
    converge
  end

  def converge
    converge_node 'subversion::client'
  end

end