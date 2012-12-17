require 'yaml'

class Project
  attr_accessor name, todos, notes

  def initialize(file)
    # TODO load file with todos and notes
    # file should be loaded from ~/.tassel/projects/*
    project = YAML.load_file(file)
    name = project[:name]
    todos = project[:todos]
    notes = project[:notes]
  end
end
