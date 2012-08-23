require File.expand_path('../helpers', __FILE__)

describe 'subversion::client' do

  include Helpers::Subversion

  it 'installs the subversion package' do
    package("subversion").must_be_installed
  end

  it 'installs the platform specific extra packages' do
    case node['platform']
    when "ubuntu"
      if node['platform_version'].to_f < 8.04
        package("subversion-tools").must_be_installed
        package("libsvn-core-perl").must_be_installed
      else
        package("subversion-tools").must_be_installed
        package("libsvn-perl").must_be_installed
      end
    when "centos","redhat","fedora"
      package("subversion-devel").must_be_installed
      package("subversion-perl").must_be_installed
    else
      package("subversion-tools").must_be_installed
      package("libsvn-perl").must_be_installed
    end
  end
end