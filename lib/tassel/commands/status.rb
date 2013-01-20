module Tassel
  module Handlers
    class Status
      register_command do
        label('status')
        mnemonic('s')
        worker(self)
      end
    end
  end
end

