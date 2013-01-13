module Tassel
  class Config
    def initialize() #config_file = '~/.tassel/config.yml')
      # TODO load config file from ~/.tassel/config.yml
      #config = YAML.load_file(config_file)
      @config = {
        :projects => []
      }
    end

    def save(config_file = '~/.tassel/config.yml')
      File.open(config_file, 'w') do |out|
        YAML.dump(@config, out)
      end
    end

    def [](key)
      @config[key]
    end
  end
end
