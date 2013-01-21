module Todo
  class List
    def save
      File.open(@path, 'w') do |f|
        self.each do |t|
          f.write "#{t.orig}\n"
        end
      end
    end
  end
end
