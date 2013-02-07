require 'fileutils'
require 'tassel/command'
require 'tassel/config'
require 'tassel/logging'
require 'term/ansicolor'
require 'todo-txt'

# Main class for starting Tassel and loading commands to be interacted with.
#
# Using Tassel#run will run as a command line application. This includes
# displaying a splash to the user and managing interactions with a menu of
# commands.
module Tassel
  class << self
    include Tassel::Logging

    attr_reader :projects, :config, :list
  end

  class Color
    extend Term::ANSIColor
  end

  def self.init!
    # load our monkey patches for Todo
    Dir.glob(File.expand_path('../todo-txt/*.rb', __FILE__)) do |file|
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

  # Run Tassel as a command line application. This will display a splash and
  # manage user input to interact with a displayed menu.
  def self.run
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
  def self.register_command(label, opts = {}, &block)
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
  def self.worker(key)
    cmd = @commands.find { |c| c.label == key.to_s || c.opts[:mnemonic] == key.intern }
    worker = cmd.worker unless cmd.nil?

    # return a default nil worker if the command isn't found
    worker = lambda { } if worker.nil?
    worker
  end

  private

  # Load command files from a well known location.
  def self.load_command_files
    logger.info("Loading commands from #{File.expand_path('../commands/*.rb', __FILE__)}")

    Dir.glob(File.expand_path('../tassel/commands/*.rb', __FILE__)) do |file|
      logger.info("  Loading #{file}")
      load file
    end
    @commands.sort! do |a, b|
      a.label <=> b.label
    end
  end

  # Save configuration and tasks.
  def self.save!
    @config.save
    @list.save
  end

  # Show the splash message.
  def self.show_splash
    puts Color.bold { "Welcome to Tassel!" }, ''
  end

  # Show the menu by going through each command.
  def self.show_menu
    puts '', "#{Color.bold { '*** Commands ***' }}"

    @commands.each_with_index do |c, i|
      print "#{c.opts[:mnemonic]}|" unless c.opts[:mnemonic].nil?
      print "#{Color.bold { c.label }}"
      # add a line return at the menu width
      print "\n" if i % @config.menu_width == (@config.menu_width - 1)
      print ' ' * @config.menu_spacing if i % @config.menu_width != (@config.menu_width - 1)
    end
    print "\n#{Color.bold { 'Sup?' } }> "
  end
end
