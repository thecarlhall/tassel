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
      @command_handlerd_by_mnemonic = {}

      projects = {}
      config[:projects].each do |pd|
        projects[pd] = Project.new(pd)
      end

      show_splash
      load_commandhandler_files
      show_menu
    end

    private

    def load_commandhandler_files
      instance_eval(File.expand_path('../tasks', __FILE__))

      @command_handlers_by_label ||= {}
      @command_handlers_by_mnemonic ||= {}

      @command_handlers_by_label[label] = command
      @command_handlers_by_mnemonic[mnemonic] = command
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
  end
end
