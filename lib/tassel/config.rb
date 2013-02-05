require 'tassel/logging'

module Tassel
  class Config
    include Tassel::Logging

    PROTECTED_KEYS = [:tassel_dir, :tassel_home, :config_file]

    def initialize
      @config = {}
      @config[:tassel_home] ||= File.join(Dir.home, '.tassel')
      @config[:config_file] ||= File.join(@config[:tassel_home], 'config.yml')

      logger.debug("Loading config from #{@config[:config_file]}")

      # load config file from ~/.tassel/config.yml
      Dir.mkdir(@config[:tassel_home]) unless File.directory?(@config[:tassel_home])
      FileUtils.touch(@config[:config_file]) unless File.file?(@config[:config_file])
      loaded_config = YAML.load_file(@config[:config_file])
      @config.merge!(loaded_config) unless loaded_config === false

      @config[:todo_file] ||= File.join(@config[:tassel_home], 'todo.txt')

      @config[:sort_by] ||= :project
      @config[:input_format] ||= :form
      @config[:initial_command] ||= :l

      # iterate through the config and create attribute accessors.
      @config.keys.each do |key|
        if self.respond_to?(key.intern) || self.respond_to?("#{key}=".intern)
          puts "Can't methodize key [#{key.inspect}]"
        else
          instance_eval("def #{key.to_s};@config[#{key.inspect}];end")
          instance_eval("def #{key.to_s}=(val);@config[#{key.inspect}]=val;end")
        end
      end

      Dir.mkdir(tassel_home) unless File.directory?(tassel_home)
    end

    # Get the value for a key in this configuration
    #
    # @return The value set at the key or nil.
    def [](key); @config[key] end

    # Save the current config to the same file it was loaded from.
    def save
      conf = @config.reject { |k, v| PROTECTED_KEYS.include?(k) }
      File.open(config_file, 'w') do |out|
        YAML.dump(conf, out)
      end
    end
  end
end
