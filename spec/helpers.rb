require 'chefspec'
require 'fauxhai'

# mock ohai attributes
def mock_ohai(attrs = {})
  Fauxhai.mock do |node|
    attrs.each do |key, val|
      node[key] = val
    end
  end
end

# converge node with the given recipe
def converge_node(recipe)
  ChefSpec::ChefRunner.new.converge recipe
end