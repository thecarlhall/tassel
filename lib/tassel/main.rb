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
      # load our monkey patches for Todo
      Dir.glob(File.expand_path('../../todo-txt/*.rb', __FILE__)) do |file|
        load file
      end

      @config = Config.new

      # initialize the commands container
      @commands = []
      load_command_files

      logger.info("Config: #{@config.todo_file}")
      FileUtils.touch(@config.todo_file) unless File.file?(@config.todo_file)
      @list = Todo::List.new(@config.todo_file)
    end

    # Get a logger for this class. Create a new one if necessary.
    #
    # @return [Logger] The logger set for this class.
    def logger
      @logger ||= Logger.new(File.join(@config.tassel_home, 'tassel.log'))
    end

    # Run Tassel as a command line application. This will display a splash and
    # manage user input to interact with a displayed menu.
    def run
      show_splash

      # fire an initial command if specified
      cmd = worker(@config[:initial_command]).call

      # start the command loop
      command = ''
      begin
        while true
          show_menu
          command = STDIN.gets

          exit if command.nil?
          command.chomp!.downcase

          cmd = worker(command).call
        end
      ensure
        puts 'Later.'
      end
    end

    # Register a command. This is an entry point for our DSL. The command will
    # be automatically displayed in the menu.
    #
    # @return [Command] The command created by this function.
    def register_command(label, opts = {}, &block)
      command = Command.new
      command.label = label
      command.opts = opts
      command.worker = block
      command.validate

      @commands << command
      command
    end

    # Get the worker for the command associated to a key where the key is
    # compared to the label and the mnemonic associated to a command.
    #
    # @return Worker related to the found command or nil
    def worker(key)
      cmd = @commands.find { |c| c.label == key.to_s || c.opts[:mnemonic] == key.intern }
      worker = cmd.worker unless cmd.nil?

      # return a default nil worker if the command isn't found
      worker = lambda { } if worker.nil?
      worker
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
        a.label <=> b.label
      end
    end

    # Save configuration and tasks
    def save!
      @config.save
      @list.save
    end

    # Show the splash messages
    def show_splash
      puts Color.bold { "Welcome to Tassel!" }, ''
    end

    # Show the menu
    def show_menu
      puts '', "#{Color.bold { '*** Commands ***' }}"

      @commands.each_with_index do |c, i|
        print "#{c.opts[:mnemonic]}|" unless c.opts[:mnemonic].nil?
        print "#{Color.bold { c.label }}"
        print "\n" if i % 5 == 4
        print ' ' * 3 if i % 5 != 4
      end
      print "#{Color.bold { 'Sup?' } }> "
    end
  end
end
