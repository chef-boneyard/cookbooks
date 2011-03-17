# This recipe is for compiling redis from source.
#
#
directory node[:redis][:build_dir] do
  owner node[:redis][:build_user]
  mode "0755"
  recursive true
end

remote_file ::File.join(node[:redis][:build_dir], ::File.basename(node[:redis][:source_url])) do
  source node[:redis][:source_url]
  mode "0644"
end

script "unpack and make" do
  cwd node[:redis][:build_dir]
  code <<EOS
  tar -xzf #{tarball}
  cd #{tarball.sub('.tar.gz','')}
  make
  make install
EOS
  interpreter "bash"
end

