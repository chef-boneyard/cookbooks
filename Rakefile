
desc "Test the cookbooks for syntax errors"
task :test do
  puts "** Testing your cookbooks for syntax errors"
  Dir[ File.join(File.dirname(__FILE__), "**", "*.rb") ].each do |recipe|
    print "Testing recipe #{recipe}: "
    sh %{ruby -c #{recipe}} do |ok, res|
      if ! ok
        raise "Syntax error in #{recipe}"
      end
    end
  end
end

task :default => [ :test ]

