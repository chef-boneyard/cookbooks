# Yay for helpers!

class Chef
  class Recipe
    def dist_only?
      node[:packages][:dist_only]
    end
  end
end
