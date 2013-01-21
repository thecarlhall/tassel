module Tassel
  class Config
    attr_accessor :config_file

    def initialize
      config_file = File.join(File.join(Dir.home, '.tassel'), 'config.yml')

      # load config file from ~/.tassel/config.yml
      FileUtils.touch(config_file) unless File.file?(config_file)
      @config = YAML.load_file(config_file) || {}

      @config[:tassel_home] ||= File.join(Dir.home, '.tassel')
      @config[:config_file] ||= File.join(@config[:tassel_home], 'config.yml')
      @config[:todo_file] ||= File.join(@config[:tassel_home], 'todo.txt')

      @config[:sort_by] ||= :project
      @config[:input_format] ||= :form

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

    def [](key)
      @config[key]
    end

    # Save the current config to the same file it was loaded from.
    def save
      File.open(config_file, 'w') do |out|
        YAML.dump(@config, out)
      end
    end
  end
end
