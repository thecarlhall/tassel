require 'tassel/config'
require 'tassel/command'
require 'term/ansicolor'
require 'terminal-table'
require 'yaml'

module Tassel
  class Color
    extend Term::ANSIColor
  end

  # Convenience method for call Tassel::Main.register_command
  def self.register_command(worker, &block)
    Tassel::Main.register_command(worker, &block)
  end

  class Main
    attr_accessor :projects

    @commands ||= []

    def initialize
      config = Tassel::Config.new

      projects = {}
      config[:projects].each do |pd|
        projects[pd] = Project.new(pd)
      end

      show_splash
      load_command_files
      show_menu
    end

    # Register a command. The command will be automatically displayed in the
    # menu.
    def self.register_command(worker, &block)
      command = Command.new
      command.worker = worker.new
      yield command
      #command.instance_eval(&block)
      command.validate

      @commands << command
      #p @commands

      command
    end

    private

    def load_command_files
      Dir.glob(File.expand_path('../tassel/commands/*.rb', __FILE__)) do |file|
        puts "Loading #{file}"
        load file
      end
    end

    # Show the splash messages
    def show_splash
      puts Color.bold { "Welcome to Tassel!" }, ''
    end

    # Show the menu
    def show_menu
      puts "#{Color.bold { '*** Commands ***' }}"
      @commands.each_with_index do |h, i|
        puts "#{i}: #{Color.bold { h[:label] }}"
      end unless @commands.nil?
    end
  end
end
