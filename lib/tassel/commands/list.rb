module Tassel
  module Handlers
    class List
      register_command do
        label('list')
        mnemonic('l')
        worker(self)
      end
    end
  end
end

