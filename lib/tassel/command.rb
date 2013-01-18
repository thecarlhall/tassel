module Tassel
  class Command
    attr_accessor :label, :mnemonic, :worker

    def initialize(&block)
      instance_eval(options = {}, &block)
    end
  end
end
