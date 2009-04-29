TOPDIR = File.expand_path(File.join(File.dirname(__FILE__), ".."))
COMPANY_NAME = "Opscode, Inc."
NEW_COOKBOOK_LICENSE = :apachev2

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

desc "Create a new cookbook (with COOKBOOK=name)"
task :new_cookbook do
  create_cookbook(File.join(TOPDIR, "cookbooks"))
  create_readme(File.join(TOPDIR, "cookbooks"))
end

def create_cookbook(dir)
  raise "Must provide a COOKBOOK=" unless ENV["COOKBOOK"]
  puts "** Creating cookbook #{ENV["COOKBOOK"]}"
  sh "mkdir -p #{File.join(dir, ENV["COOKBOOK"], "recipes")}" 
  unless File.exists?(File.join(dir, ENV["COOKBOOK"], "recipes", "default.rb"))
    open(File.join(dir, ENV["COOKBOOK"], "recipes", "default.rb"), "w") do |file|
      file.puts <<-EOH
#
# Cookbook Name:: #{ENV["COOKBOOK"]}
# Recipe:: default
#
# Copyright #{Time.now.year}, #{COMPANY_NAME}
#
EOH
      case NEW_COOKBOOK_LICENSE
      when :apachev2
        file.puts <<-EOH
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
EOH
      when :none
        file.puts <<-EOH
# All rights reserved - Do Not Redistribute
#
EOH
      end
    end
  end
end

def create_readme(dir)
  raise "Must provide a COOKBOOK=" unless ENV["COOKBOOK"]
  puts "** Creating README for cookbook: #{ENV["COOKBOOK"]}"
  unless File.exists?(File.join(dir, ENV["COOKBOOK"], "README.rdoc"))
    open(File.join(dir, ENV["COOKBOOK"], "README.rdoc"), "w") do |file|
      file.puts <<-EOH
= DESCRIPTION:

= REQUIREMENTS:

== Platform:

== Cookbooks:

= ATTRIBUTES: 

= USAGE:

= LICENSE and AUTHOR:
      
EOH
    end
  end
end

task :default => [ :test ]

desc "Build a bootstrap.tar.gz"
task :build_bootstrap do
  bootstrap_files = Rake::FileList.new
  %w(apache2 runit couchdb stompserver chef passenger ruby).each do |cookbook|
    bootstrap_files.include "#{cookbook}/**/*"
  end

  tmp_dir = "tmp"
  cookbooks_dir = File.join(tmp_dir, "cookbooks")
  rm_rf tmp_dir
  mkdir_p cookbooks_dir
  bootstrap_files.each do |fn|
    f = File.join(cookbooks_dir, fn)
    fdir = File.dirname(f)
    mkdir_p(fdir) if !File.exist?(fdir)
    if File.directory?(fn)
      mkdir_p(f)
    else
      rm_f f
      safe_ln(fn, f)
    end
  end

  chdir(tmp_dir) do
    sh %{tar zcvf bootstrap.tar.gz cookbooks}
  end
end