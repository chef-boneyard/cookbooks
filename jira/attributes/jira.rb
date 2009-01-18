
jira_virtual_host_name "jira.#{domain}" unless attribute?("jira_virtual_host_name")
jira_virtual_host_alias "jira.#{domain}" unless attribute?("jira_virtual_host_alias")
# type-version-standalone
jira_version "enterprise-3.13.1" unless attribute?("jira_version")
jira_install_path "/srv/jira" unless attribute?("jira_install_path")
jira_database "mysql" unless attribute?("jira_database")
jira_database_host "localhost" unless attribute?("jira_database_host")
jira_database_user "jira" unless attribute?("jira_database_user")
jira_database_password "change_me" unless attribute?("jira_database_password")
jira_run_user "www-data" unless attribute?("jira_run_user")