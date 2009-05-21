packages Mash.new unless attribute?("packages")

# Toggle for recipes to determine if we should rely on distribution packages
# or gems.
packages[:dist_only] = false unless packages.has_key?(:dist_only)
