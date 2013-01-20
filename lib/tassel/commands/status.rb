module Tassel
  module Commands
    class Status
      Tassel.register_command Tassel::Commands::Status do |c|
        c.label = 'status'
        c.mnemonic = 's'
      end
    end
  end
end
