module Tassel
  module Commands
    class Edit
      Tassel.register_command 'edit', :mnemonic => :e do |params|
        if Tassel.config.input_format == :form
        else
        end
      end
    end
  end
end
