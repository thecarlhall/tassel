register_command 'add', :mnemonic => :a do
  if @config.input_format == 'todo.txt'
    print 'Type your task in todo.txt format> '
    task = gets.chomp
  else
    print 'Text: '
    text = gets.chomp
    print 'Priority: '
    priority = gets.chomp
    print 'Project: '
    project = gets.chomp
    print 'Context: '
    context = gets.chomp

    task = "(#{priority}) #{text} +#{project} @#{context}"
  end
  @list.push(Todo::Task.new(task))
end
