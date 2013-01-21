require 'fileutils'
require 'logger'
require 'tassel/config'
require 'tassel/command'
require 'term/ansicolor'
require 'terminal-table'
require 'todo-txt'
require 'yaml'

module Tassel
  # Main class for starting Tassel and loading commands to be interacted with.
  #
  # Using Tassel#run will run as a command line application. This includes
  # displaying a splash to the user and managing interactions with a menu of
  # commands.
  class Main
    attr_accessor :projects

    class Color
      extend Term::ANSIColor
    end

    def initialize
      # load our monkey patch to Todo::List#save
      load File.expand_path('../../todo-txt/list.rb', __FILE__)

      @config = Config.new

      # initialize the commands container
      @commands = []

      logger.info("Config: #{@config.todo_file}")
      FileUtils.touch(@config.todo_file) unless File.file?(@config.todo_file)
      @list = Todo::List.new(@config.todo_file)
    end

    def logger
      @logger ||= Logger.new(File.join(@config.tassel_home, 'tassel.log'))
    end

    # Run Tassel as a command line application. This will display a splash and
    # manage user input to interact with a displayed menu.
    def run
      show_splash

      load_command_files

      # start the command loop
      command = ''
      begin
        while true
          show_menu
          command = STDIN.gets

          exit if command.nil?
          command.chomp!.downcase

          cmd = @commands.select { |c| c.mnemonic == command.intern }[0]
          cmd.worker.call unless cmd.nil?
        end
      ensure
        puts 'Later.'
      end
    end

    # Register a command. This is an entry point for our DSL. The command will
    # be automatically displayed in the menu.
    def register_command(label, mnemonic, &block)
      command = Command.new
      command.label = label
      command.mnemonic = mnemonic
      command.worker = block
      command.validate

      @commands << command
      command
    end

    private

    # Load command files from a well known location
    def load_command_files
      logger.info("Loading commands from #{File.expand_path('../commands/*.rb', __FILE__)}")

      Dir.glob(File.expand_path('../commands/*.rb', __FILE__)) do |file|
        logger.info("Loading #{file}")
        instance_eval(File.read(file))
      end
      @commands.sort! do |a, b|
        a.mnemonic <=> b.mnemonic
      end
    end

    def save
      @config.save
      @list.save
    end

    # Show the splash messages
    def show_splash
      puts Color.bold { "Welcome to Tassel!" }
    end

    # Show the menu
    def show_menu
      puts '', "#{Color.bold { '*** Commands ***' }}"

      @commands.each_with_index do |c, i|
        print "#{c.mnemonic}|#{Color.bold { c.label }}"
        print "\n" if i % 5 == 4
        print ' ' * 3 if i % 5 != 4
      end
      print "#{Color.bold { 'Sup?' } }>"
    end
  end
end
