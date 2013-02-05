module Tassel
  module Commands
    class Status
      Tassel.register_command 'status', :mnemonic => :t do
        puts 'STATUS'
      end
    end
  end
end

