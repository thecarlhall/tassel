module Tassel
  module Commands
    class List
      Tassel.register_command 'list', :mnemonic => :l do
        tasks = nil
        case Tassel.config.sort_by
        when :context
          tasks = Tassel.list.sort { |a, b| a.contexts[0] <=> b.contexts[0] }
        when :priority
          tasks = Tassel.list.sort { |a, b| b.priority <=> a.priority }
        else
          tasks = Tassel.list.sort { |a, b| a.projects[0] <=> b.projects[0] }
        end

        tasks.each do |task|
          puts task.orig
        end unless tasks.nil?
      end
    end
  end
end
