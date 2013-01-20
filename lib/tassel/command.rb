module Tassel
  class Command
    attr_accessor :label, :mnemonic, :worker

    def validate
      raise ArgumentError, 'Label and mnemonic must not be empty' if label.empty? || mnemonic.empty?
    end
  end
end
