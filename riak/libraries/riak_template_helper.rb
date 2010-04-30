module RiakTemplateHelper
  
  #
  # erl_sym?(str)
  #
  # Returns a boolean indicating whether the value associated with an option
  # should be treated as an Erlang symbol and, hence, not quoted.
  #
  def erl_sym?(str)
    ["storage_backend", "errlog_type"].include?(str)
  end
  
  def erl_prepare(opts)
    opts.inject([]) do |arr, (opt, val)|
      if val.is_a?(String) && !(erl_sym?(opt))
        val_str = "\"#{val}\""
      else
        val_str = val.to_s
      end
      arr << "\{#{opt}, #{val_str}\}"
    end
  end
  
  def configify(config)
    core = erl_prepare(config["core"])
    storage_backend_options = erl_prepare(config["kv"].delete("storage_backend_options"))
    kv = erl_prepare(config["kv"])
    kernel = erl_prepare(config["kernel"])
    sasl_error_logger = erl_prepare(config["sasl"].delete("sasl_error_logger"))
    sasl = erl_prepare(config["sasl"])
    
    {:core => core, :kernel => kernel,
      :kv => kv, :sasl => sasl, :sasl_error_logger => sasl_error_logger,
      :storage_backend_options => storage_backend_options}
  end
end
