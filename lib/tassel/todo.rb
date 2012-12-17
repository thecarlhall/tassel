require 'yaml'

module Tassel
  class TodoList
    def initialize(config, name)
      @config = config
      @name = name
      @filename = "#{config[:todo_path]}/#{name}.yml"
      @list = YAML.load_file(@filename)
    end

    def load
    end

    def save
      File.open(@filename, ‘w’) do |out|
        YAML.dump(@list, out)
      end
    end

    # Add task
    def add(item)
      raise ArgumentError "Lacking argument [name]" if item.nil?

      # Append task to file
      contents = File.read('todo.td')

      File.open('todo.td', 'w') do |f|
        todo = contents + @argv[1] + "\n"
        f.write(todo)
      end
    end

    # List all tasks
    def list
      @list
      # Read content
      contents = File.read('todo.td')
      puts "No tasks" unless contents

      # Show it with ids
      i = 0
      contents.each_line do |todo|
        i += 1
        puts "##{i} - #{todo}"
      end
    end

    # Finished a task
    def done
      unless @argv[1]
        puts "Lacking argument [id]"
        exit
      end

      # Put tasks into an array
      todos = File.read('todo.td').split("\n")

      unless todos
        puts "No tasks"
        exit
      end

      puts "Completed task: " + todos[@argv[1].to_i - 1]

      # Delete task from array and make string
      todos.delete_at(@argv[1].to_i - 1)
      content = todos.join("\n")

      # Update file
      File.open('todo.td', 'w') do |f|
        f.write(content)
      end
    end

    def [](id)
      @list[id]
    end
  end

  class TodoItem
    attr_accessor :title, :description, :state
  end
end
