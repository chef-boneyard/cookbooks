require 'net/http'
require 'net/https'

class Tomcat
  # wrapper arount tomcat manager http api
  
  def initialize(opts={})
    @configuration = opts
  end
  
  def configuration
    @configuration
  end
  
  def install
    tag_param = (@configuration[:tag])?"&tag=#{@configuration[:tag]}":""
    get("/manager/deploy?path=#{@configuration[:path]}&war=file:#{@configuration[:war]}")
  end
  
  def update
    tag_param = (@configuration[:tag])?"&tag=#{@configuration[:tag]}":""
    get("/manager/deploy?path=#{@configuration[:path]}&war=file:#{@configuration[:war]}&update=true")
  end
  
  def undeploy
    get("/manager/undeploy?path=#{@configuration[:path]}")
  end
  
  def reload
    get("/manager/reload?path=#{@configuration[:path]}")
  end
  
  def start
    get("/manager/start?path=#{@configuration[:path]}")
  end
  
  def stop
    get("/manager/stop?path=#{@configuration[:path]}")
  end

  def status
    get("/manager/status")
  end

  def get(url)
    site = Net::HTTP.new(@configuration[:host], @configuration[:port])
    site.use_ssl = false
    site.read_timeout=180
    result = nil
    begin
      result = site.get2( url, 'Authorization' => 'Basic ' + ["#{@configuration[:admin]}:#{@configuration[:password]}"].pack('m').strip)
    rescue Timeout::Error => e
      raise RuntimeError, "Timeout Error while calling #{url}", caller
    end
    result
  end

end
