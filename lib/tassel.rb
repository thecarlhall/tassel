require 'tassel/version'
require 'yaml'

module Tassel
  def initialize
    @config = Tassel::Config.new
    @projects = {}
  end

  class Config
    attr_accessor :config, :todo_path

    def initialize
      # TODO load config file from ~/.tassel/config.yml
      config = YAML.load_file('config.yml')
    end

    def save
      File.open('config.yml', ‘w’) do |out|
        YAML.dump(@config, out)
      end
    end

    # Lists help information
    def help
      puts <<-HELP
Commands for Todo.rb:
  add [task name] - Add a new task
  list - Lists all tasks
  done [task id] - Complete a task
  help - Prints out this information
      HELP
    end
  end
end

tassel = Tassel.new
