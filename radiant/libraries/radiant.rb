class Chef
  class Recipe
    def edge?
      @node[:radiant][:edge]
    end
    
    def bootstrap?
      @node[:radiant][:bootstrap]
    end
  end
end