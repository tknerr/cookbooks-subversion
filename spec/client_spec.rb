require File.expand_path('../helpers', __FILE__)

describe ChefRun.new('subversion::client') do
    
  %w{ redhat centos fedora ubuntu debian }.each do |platform|
    context "on platform #{platform}" do
      before(:all) { mock_and_converge(platform) }  
      it { should install_package 'subversion' }
      case platform
      when 'ubuntu'
        it { should install_package "subversion-tools" }
        context "version < 8.04" do
          before { mock_and_converge('ubuntu', '7.10') }
          it { should install_package "libsvn-core-perl" }
        end
        context "version >= 8.04" do
          before { mock_and_converge('ubuntu', '8.04') }
          it { should install_package "libsvn-perl" }
        end
      when 'centos', 'redhat', 'fedora'
        it { should install_package "subversion-devel" }
        it { should install_package "subversion-perl" }
      when 'debian'
        it { should install_package "subversion-tools" }
        it { should install_package "libsvn-perl" }
      end
    end
  end

  def mock_and_converge(platform, version = 0)
    mock_ohai(platform: platform, platform_version: version)
    subject.converge
  end
end