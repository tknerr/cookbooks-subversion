

# install rvm and default 1.9.2 ruby for the vagrant user

node.set['rvm']['user_installs'] = [
  { 'user'          => 'vagrant',
    'default_ruby'  => 'ruby-1.9.2-p320',
    'rubies'        => [] 
  }
]

include_recipe "rvm::user"