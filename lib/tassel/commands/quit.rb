module Tassel
  module Commands
    class Quit
      Tassel.register_command 'quit', :mnemonic => :q do
        Tassel.save!
        exit
      end
    end
  end
end
