require File.expand_path('../helpers', __FILE__)

describe 'subversion::server' do

  include Helpers::Subversion

  it 'installs the subversion package' do
    package("serverfails").must_be_installed
  end

end