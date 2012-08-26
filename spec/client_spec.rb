require 'chefspec'

describe 'subversion::client' do

  let (:chef_run) { ChefSpec::ChefRunner.new('..').converge 'subversion::client' }
  
  it 'should install the subversion package' do
    chef_run.should install_package 'subversion'
  end

end