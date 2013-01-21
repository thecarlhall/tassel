require 'tassel/config'
require 'tassel/command'
require 'term/ansicolor'
require 'terminal-table'
require 'yaml'

module Tassel
  class Main
    attr_accessor :projects

    class Color
      extend Term::ANSIColor
    end

    def initialize
      config = Tassel::Config.new

      projects = {}
      config[:projects].each do |pd|
        projects[pd] = Project.new(pd)
      end

      @commands ||= []
    end

    def run
      show_splash
      load_command_files
      show_menu
    end

    # Register a command. The command will be automatically displayed in the
    # menu.
    def self.register_command(worker, label, mnemonic)
      command = Command.new
      command.worker = worker.new
      command.label = label
      command.mnemonic = mnemonic
      command.validate

      @commands << command
      p command, @commands

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
