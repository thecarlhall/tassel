require 'rainbow'
require 'tassel/config'
require 'term/ansicolor'
require 'terminal-table'
require 'yaml'

module Tassel
  class Color
    extend Term::ANSIColor
  end

  class Main
    attr_accessor :projects

    def initialize
      config = Tassel::Config.new

      @command_handlers_by_label = {}
      @command_handlerd_by_mnemonic = {}

      projects = {}
      config[:projects].each do |pd|
        projects[pd] = Project.new(pd)
      end

      ## TODO load handlers from lib/tassel/handlers

      show_splash
      show_menu
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
        puts "#{i}: #{h[:label]}"
      end
      puts " 1: #{Color.bold { 'a' }}dd"
      puts " 2: #{Color.bold { 'l' }}ist"
      puts " 3: #{Color.bold { 'd' }}one"
    end

    # Register a command. The command will be automatically displayed in the
    # menu.
    def register_command(options = {})
      raise ArgumentError, 'Must provide `label` and `mnemonic`' unless options.has_key?('label') && options.has_key?('mnemonic')

      @command_handlers_by_label[label] = h
      @command_handlers_by_mnemonic[mnemonic] = h
    end
  end
end
