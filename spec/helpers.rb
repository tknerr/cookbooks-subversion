require 'chefspec'
require 'fauxhai'

# ChefRun subject  
class ChefRun
  def initialize(recipe)
    @recipe = recipe
  end

  def converge
    @runner = ChefSpec::ChefRunner.new(:cookbook_path => ['..'])
    @runner.converge @recipe
  end

  def method_missing(name, *args, &block)
    @runner.send(name, *args, &block)
  end

  def to_s
    "ChefRun for recipe[#{@recipe}]"
  end
end

# mock ohai attributes
def mock_ohai(attrs = {})
  Fauxhai.mock do |node|
    attrs.each do |key, val|
      node[key] = val
    end
  end
end

