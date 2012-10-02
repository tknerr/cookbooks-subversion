require 'faster_require'
require 'foodcritic'

desc "default: run tests"
task :default=> [:test]

desc "run all tests"
task :test => [:foodcritic, :chefspec]

desc "run foodcritic lint checks"
task :foodcritic do 
  sh "bundle exec foodcritic --epic-fail any #{File.dirname(__FILE__)}", :verbose=>false
end

desc "run chefspec examples"
task :chefspec do
  sh "bundle exec rspec", :verbose=>false
end