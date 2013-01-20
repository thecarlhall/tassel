module Tassel
  module Commands
    class Add
      Tassel.register_command Tassel::Commands::Add do |c|
        c.label = 'add'
        c.mnemonic = 'a'
      end
    end
  end
end
