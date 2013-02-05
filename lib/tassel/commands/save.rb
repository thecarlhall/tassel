module Tassel
  module Commands
    class Save
      Tassel.register_command 'save', :mnemonic => :s do
        Tassel.save!
      end
    end
  end
end
