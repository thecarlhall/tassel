require 'todo-txt'
require 'yaml'

class Project
  attr_accessor name, todos, notes

  def initialize(projects_dir, name)
    # TODO load files with todos and notes
    # file should be loaded from ~/.tassel/projects/*
    todos = Todo::List.new("~/.tassel/projects/#{name}/todo.txt")
    notes = YAML.load_file("~/.tassel/projects/#{name}/notes.txt")
  end
end
