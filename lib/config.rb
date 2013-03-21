require 'yaml'

module Zucchini
  class Config

    def self.base_path
      @@base_path
    end

    def self.base_path=(base_path)
      @@base_path = base_path
      @@config    = YAML::load_file("#{base_path}/support/config.yml")
      @@default_device_name = nil
      devices.each do |device_name, device|
        if device['default']
          raise "Default device already provided" if @@default_device_name
          @@default_device_name = device_name
        end
      end
    end

    def self.app
      device_name = ENV['ZUCCHINI_DEVICE'] || @@default_device_name
      app_path    = File.absolute_path(devices[device_name]['app'] || @@config['app'] || ENV['ZUCCHINI_APP'])

      if device_name == 'iOS Simulator' && !File.exists?(app_path)
        raise "Can't find application at path #{app_path}"
      end
      app_path
    end

    def self.resolution_name(dimension)
      @@config['resolutions'][dimension.to_i]
    end

    def self.devices
      @@config['devices']
    end

    def self.default_device_name
      @@default_device_name
    end

    def self.device(device_name)
      device_name ||= @@default_device_name
      raise "Neither default device nor ZUCCHINI_DEVICE environment variable was set" unless device_name
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
