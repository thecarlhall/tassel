module Tassel
  module Commands
    class Add
      Tassel.register_command 'add', :mnemonic => :a do
        if Tassel.config.input_format == :form
          print 'Text: '
          text = gets.chomp
          print 'Priority: '
          priority = gets.chomp
          print 'Project: '
          project = gets.chomp
          print 'Context: '
          context = gets.chomp

          task = "(#{priority}) #{text} +#{project} @#{context}"
        else
          print 'Type your task in todo.txt format> '
          task = gets.chomp
        end
        Tassel.list.push(Todo::Task.new(task))
      end
    end
  end
end
