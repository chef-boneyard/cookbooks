module RiakTemplateHelper
  def prepare(opts)
    opts.inject([]) do |arr, (opt, val)|
      if val.is_a?(String)
        val_str = "\"#{val}\""
      else
        val_str = val.to_s
      end
      arr << "\{#{opt}, #{val_str}\}"
    end
  end
  
  def configify(config)    
    core = prepare(config["core"])
    storage_backend_options = prepare(config["kv"].delete("storage_backend_options"))
    kv = prepare(config["kv"])
    
    {:core => core, :kv => kv, :storage_backend_options => storage_backend_options}
  end
end
