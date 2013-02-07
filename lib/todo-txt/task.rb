module Todo
  class Task
    def initialize(task)
      @orig = task.chomp
    end

    # The regex used to match priorities.
    # todo.txt only uses a-z but I wanted numbers.
    def self.priotity_regex
      /^\([A-Za-z0-9]\)\s+/
    end
  end
end
