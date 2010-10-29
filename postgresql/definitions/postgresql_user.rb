define :postgresql_user, :action => :create do
  include_recipe "postgresql::server"

  case params[:action]
  when :create
    privileges = { :superuser => false, :createdb => false, :inherit => true, :login => true }
    privileges.merge! params[:privileges] if params[:privileges]
    privileges = privileges.to_a.map! { |p,b| (b ? '' : 'NO') + p.to_s.upcase }.join(' ')

    if params[:password]
      password = "PASSWORD '#{params[:password]}'"
    end

    sql = "#{params[:name]} #{privileges} #{password}"
    exists = "psql -c 'SELECT usename FROM pg_catalog.pg_user' | grep '^ #{params[:name]}$'"

    execute "alter postgresql user #{params[:name]}" do
      user "postgres"
      command "psql -c \"ALTER ROLE #{sql}\""
      only_if exists, :user => "postgres"
    end

    execute "create postgresql user #{params[:name]}" do
      user "postgres"
      command "psql -c \"CREATE ROLE #{sql}\""
      not_if exists, :user => "postgres"
    end
  when :drop
    execute "psql -c 'DROP ROLE IF EXISTS #{params[:name]}'" do
      user "postgres"
    end
  end
end
