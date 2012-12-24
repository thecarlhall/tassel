require 'tassel/version'
require 'yaml'

module Tassel
  def initialize
    @config = Tassel::Config.new

    @projects = {}
    @config[:projects].each do |pd|
      @projects[pd] = Project.new(pd)
    end
  end

  # Lists help information
  def help
    puts <<-HELP
Commands for Tassel:
  a[dd] <task name> - Add a new task
  l[ist]            - Lists all tasks
  d[one] <task id>  - Complete a task
  h[elp]            - Prints out this information
    HELP
  end
end
