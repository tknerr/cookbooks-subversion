source 'http://rubygems.org'

gem 'rake','~>0.9.2'

# gem versions as in bill's kitchen
gem 'test-kitchen', '~> 0.6.0'
gem 'chefspec', '~> 0.8.0'
gem 'fauxhai', '~> 0.0.3'
gem 'foodcritic','~>1.6.1'
gem 'chef', '~> 10.14.4'
gem 'librarian', '~> 0.0.20'

# extra gems required by chef on windows (see GH-5)
platforms :mswin, :mingw do
  gem 'ruby-wmi', '0.4.0'
  gem 'win32-service', '0.7.2'
end