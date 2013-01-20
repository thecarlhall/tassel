module Tassel
  module Commands
    class List
      Tassel.register_command Tassel::Commands::List do |c|
        c.label = 'list'
        c.mnemonic = 'l'
      end
    end
  end
end
