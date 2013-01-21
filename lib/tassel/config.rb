module Tassel
  class Config
    attr_accessor :tassel_home, :config_file, :todo_file

    def initialize
      @tassel_home = File.join(Dir.home, '.tassel')
      Dir.mkdir(tassel_home) unless File.directory?(tassel_home)

      @config_file = File.join(tassel_home, 'config.yml')
      @todo_file = File.join(tassel_home, 'todo.txt')

      # TODO load config file from ~/.tassel/config.yml
      @config = {}
      @config = YAML.load_file(config_file) if File.file?(config_file)
      @config[:sort] ||= :project

      # iterate through the config and create attribute accessors.
      @config.keys.each do |key|
        self.instance_eval("def #{key};@config[#{key}];end")
        self.instance_eval("def #{key}=(val);@config[#{key}]=val;end")
      end
    end

    # Save the current config to the same file it was loaded from.
    def save
      File.open(config_file, 'w') do |out|
        YAML.dump(@config, out)
      end
    end
  end
end
