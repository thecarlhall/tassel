module Todo
  class List
  puts File.expand_path('lib/todo-txt/list.rb', __FILE__)

    def save
      File.open(@path, 'w') do |f|
        self.each do |t|
          f.write "#{t.orig}\n"
        end
      end
    end
  end
end
