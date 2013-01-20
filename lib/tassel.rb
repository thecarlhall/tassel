require 'tassel/config'
require 'tassel/dsl'
require 'term/ansicolor'
require 'terminal-table'
require 'yaml'

module Tassel
  include Tassel::DSL

  class Color
    extend Term::ANSIColor
  end

  class Main
    attr_accessor :projects

    def initialize
      config = Tassel::Config.new

      @command_handlers_by_label = {}
      @command_handlers_by_mnemonic = {}

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
    def register_command(&block)
      command = Command.new
      command.instance_eval(&block)
      command.validate

      raise ArgumentError, 'Label already registered' if @command_handlers_label.has_key?(label)
      raise ArgumentError, 'mnemonic already registered' if @command_handlers_by_mnemonic.has_key?(mnemonic)

      @command_handlers_by_label[label] = command
      @command_handlers_by_mnemonic[mnemonic] = command

      command
    end

    private

    def load_command_files
      File.expand_path('../tasks', __FILE__)
    end

    # Show the splash messages
    def show_splash
      puts Color.bold { "Welcome to Tassel!" }
      puts
    end

    # Show the menu
    def show_menu
      puts "#{Color.bold { '*** Commands ***' }}"
      @command_handlers_by_label.each_with_index do |h, i|
        puts "#{i}: #{Color.bold { h[:label] }}"
      end
    end
  end
end
