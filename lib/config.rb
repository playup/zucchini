require 'yaml'

module Zucchini
  class Config 
    
    def self.base_path
      @@base_path
    end
  
    def self.base_path=(base_path)
      @@base_path = base_path
      @@config    = YAML::load_file("#{base_path}/support/config.yml")
    end
                  
    def self.app
      @@config['app']
    end
  
    def self.resolution_name(dimension)   
      @@config['resolutions'][dimension.to_i]
    end
  
    def self.devices
      @@config['devices']
    end
  
    def self.device(device_name)
      raise "Device not listed in config.yml" unless (device = devices[device_name])
      {
        :name   => device_name,
        :udid   => device['UDID'],
        :screen => device['screen']
      }
    end
    
    def self.server(server_name)
      @@config['servers'][server_name]
    end
  
    def self.url(server_name, href="")
      server_config = server(server_name)
      port = server_config['port'] ? ":#{server_config['port']}" : ""
    
      "http://#{server_config['host']}#{port}#{href}"
    end
  end                                   
end