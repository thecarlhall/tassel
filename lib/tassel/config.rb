module Tassel
  class Config
    attr_accessor :tassel_dir, :config_file

    PROTECTED_KEYS = [:tassel_dir, :tassel_home, :config_file]

    def initialize
      @tassel_dir = File.join(Dir.home, '.tassel')
      @config_file = File.join(tassel_dir, 'config.yml')

      # load config file from ~/.tassel/config.yml
      Dir.mkdir(tassel_dir) unless File.directory?(tassel_dir)
      FileUtils.touch(config_file) unless File.file?(config_file)
      @config = YAML.load_file(config_file) || {}

      @config[:tassel_home] ||= File.join(Dir.home, '.tassel')
      @config[:config_file] ||= File.join(@config[:tassel_home], 'config.yml')
      @config[:todo_file] ||= File.join(@config[:tassel_home], 'todo.txt')

      @config[:sort_by] ||= :project
      @config[:input_format] ||= :form
      @config[:initial_command] ||= :q

      # iterate through the config and create attribute accessors.
      @config.keys.each do |key|
        instance_eval("def #{key};@config[:#{key}];end")
        instance_eval("def #{key}=(val);@config[:#{key}]=val;end")
      end

      Dir.mkdir(tassel_home) unless File.directory?(tassel_home)
    end

    def method_missing
      return nil
    end

    # Get a list of keys known to this configuration
    #
    # @return [Array] An array of known keys.
    def keys; @config.keys end

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
