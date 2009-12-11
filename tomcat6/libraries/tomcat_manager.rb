
require File.join(File.dirname(__FILE__), 'tomcat')
 
class Chef
  class Resource
    class TomcatManager < Chef::Resource
        
      def initialize(name, collection=nil, node=nil)
        super(name, collection, node)
        @resource_name = :tomcat_manager
        @host = "localhost"
        @port = "8080"
        @action = :nothing
        @allowed_actions.push(:install)
        @allowed_actions.push(:start)
        @allowed_actions.push(:stop)
        @allowed_actions.push(:update)
        @allowed_actions.push(:undeploy)
        
      end
      
      def port(arg=nil)
        set_or_return(
          :port,
          arg,
          :kind_of => [ String ]
        )
      end
      
      def host(arg=nil)
        set_or_return(
          :host,
          arg,
          :kind_of => [ String ]
        )
      end
      
      def with_snmp(arg=nil)
        set_or_return(
          :with_snmp,
          arg,
          :kind_of => [ TrueClass, FalseClass ]
        )
      end

      def admin(arg=nil)
        set_or_return(
          :admin,
          arg,
          :kind_of => [ String ]
        )
      end
      
      def password(arg=nil)
        set_or_return(
          :password,
          arg,
          :kind_of => [ String ]
        )
      end
      
      def base(arg=nil)
        set_or_return(
          :base,
          arg,
          :kind_of => [ String ]
        )
      end
      
      def war(arg=nil)
        set_or_return(
          :war,
          arg,
          :kind_of => [ String ]
        )
      end
      
      def path(arg=nil)
        set_or_return(
          :path,
          arg,
          :kind_of => [ String ]
        )
      end
            
      def tag(arg=nil)
        set_or_return(
          :tag,
          arg,
          :kind_of => [ String ]
        )
      end

      def service(arg=nil)
        set_or_return(
          :service,
          arg,
          :kind_of => [ Object ]
        )
      end


 
    end
  end

  class Provider
    class TomcatManager < Chef::Provider
      
      def load_current_resource
        #super
        #@current_resource 
      end
      
      def action_install
        ensure_tomcat_manager_running
        Chef::Log.info "Running tomcat_manager[#{@new_resource.name}] install"
        tomcat = new_tomcat
        begin
          result = tomcat.install
          (!"200".eql?(result.code) || result.body.include?("FAIL"))?(Chef::Log.error "Ran tomcat_manager[#{@new_resource.name}] install failed: HTTP #{result.code} #{result.message}"):(Chef::Log.info "Ran tomcat_manager[#{@new_resource.name}] install successfully")
        rescue StandardError => e
          Chef::Log.error "Got Exception in manager action" + e
        end
      end
      
      def action_update
        ensure_tomcat_manager_running
        Chef::Log.info "Running tomcat_manager[#{@new_resource.name}] update"
        tomcat = new_tomcat 
        begin
          result = tomcat.update
          (!"200".eql?(result.code) || result.body.include?("FAIL"))?(Chef::Log.error "Ran tomcat_manager[#{@new_resource.name}] update failed: HTTP #{result.code} #{result.message}"):(Chef::Log.info "Ran tomcat_manager[#{@new_resource.name}] update successfully")
        rescue StandardError => e
          Chef::Log.error "Got Exception in manager action" + e
        end
      end
      
      def action_start
        ensure_tomcat_manager_running
        Chef::Log.info "Running tomcat_manager[#{@new_resource.name}] start"
        tomcat = new_tomcat 
        begin
          result = tomcat.start
          (!"200".eql?(result.code) || result.body.include?("FAIL"))?(Chef::Log.error "Ran tomcat_manager[#{@new_resource.name}] start failed: HTTP #{result.code} #{result.message}"):(Chef::Log.info "Ran tomcat_manager[#{@new_resource.name}] start successfully")
        rescue StandardError => e
          Chef::Log.error "Got Exception in manager action" + e
        end
      end
      
      def action_stop
        ensure_tomcat_manager_running
        Chef::Log.info "Running tomcat_manager[#{@new_resource.name}] stop"
        tomcat = new_tomcat 
        begin
          result = tomcat.stop
          (!"200".eql?(result.code) || result.body.include?("FAIL"))?(Chef::Log.error "Ran tomcat_manager[#{@new_resource.name}] stop failed: HTTP #{result.code} #{result.message}"):(Chef::Log.info "Ran tomcat_manager[#{@new_resource.name}] stop successfully")
        rescue StandardError => e
          Chef::Log.error "Got Exception in manager action" + e
        end
      end
      
      def action_undeploy
        ensure_tomcat_manager_running
        Chef::Log.info "Running tomcat_manager[#{@new_resource.name}] undeploy"
        tomcat = new_tomcat
        begin
          result = tomcat.undeploy
          (!"200".eql?(result.code) || result.body.include?("FAIL"))?(Chef::Log.error "Ran tomcat_manager[#{@new_resource.name}] undeploy failed: HTTP #{result.code} #{result.message}"):(Chef::Log.info "Ran tomcat_manager[#{@new_resource.name}] undeploy successfully")
        rescue StandardError => e
          Chef::Log.error "Got Exception in manager action" + e
        end
      end
      
      def new_tomcat(opts={})
        Tomcat.new :host => @new_resource.host,
          :port => @new_resource.port,
          :admin => @new_resource.admin,
          :password => @new_resource.password,
          :path => @new_resource.path,
          :base => @new_resource.base,
          :war => @new_resource.war,
          :name => @new_resource.name,
          :tag => @new_resource.tag
                   
      end

      def ensure_tomcat_manager_running
        unless @new_resource.with_snmp
          poll_manger_until_running
          return
        end

        require 'snmp'

        snmp = Hash.new
        # "jvmMemPoolUsed.5" is PermGen used
        snmp_names = ["jvmMemPoolUsed.5","jvmMemPoolMaxSize.5"]
        begin
          SNMP::Manager.open(:Host => "localhost", :Port => "1161", :MibModules => ['JVM-MANAGEMENT-MIB','SNMPv2-SMI']) do |m|
            response = m.get(snmp_names)
            i=0
            response.each_varbind do  |vb|
              snmp[snmp_names[i]]=vb
              i+=1
            end
          end
        rescue
          Chef::Log.info "SNMP java not responding, restarting [#{@new_resource.name}] "
          #restart passed in service, which should be the tomcat service
          @new_resource.service.run_action(:restart)
          poll_manger_until_running
        end
        perm_gen_max = (snmp["jvmMemPoolMaxSize.5"])?(snmp["jvmMemPoolMaxSize.5"].value.to_f):27262976
        perm_gen_used = (snmp["jvmMemPoolUsed.5"])?(snmp["jvmMemPoolUsed.5"].value.to_f):0
        #restart passed in service, which should be the tomcat service
        min_perm_gen = 25*1024*1024
        if ((perm_gen_max - perm_gen_used) < min_perm_gen) #node[:tomcat][:permgen_min_free_in_mb])
          Chef::Log.info "SNMP reported: PermGen Max:#{perm_gen_max/1024/1024} PermGen Used:#{perm_gen_used/1024/1024} , diff: #{(perm_gen_max/1024/1024 - perm_gen_used/1024/1024)}  is lower than #{min_perm_gen/1024/1024} "
          @new_resource.service.run_action(:restart)
          poll_manger_until_running
        end
      end
      def poll_manger_until_running
        times  = 40
        tomcat = new_tomcat
        while(times > 0)
          Chef::Log.info "waiting for tomcat_manager[#{@new_resource.name}] restart"
          begin
            tomcat.status
            times = 0
          rescue Timeout::Error
            Chef::Log.info "Timeout, waiting for another #{2*times} seconds"
          rescue
            Chef::Log.info "Manager not responding, waiting for another #{2*times} seconds"
          ensure
            sleep 2
            times-=1
          end
        end
      end
    end
  end
end
 
Chef::Platform.platforms[:default].merge! :tomcat_manager => Chef::Provider::TomcatManager
