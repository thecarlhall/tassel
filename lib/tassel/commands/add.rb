module Tassel
  module Handlers
    class Add
      register_command do
        label('add')
        mnemonic('a')
        worker(self)
    end
  end
end
