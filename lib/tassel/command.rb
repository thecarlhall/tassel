module Tassel
  class Command
    attr_accessor :label, :mnemonic, :worker

    def validate
      raise ArgumentError, "Label and mnemonic must not be empty [#{self.inspect}]" if label.nil? || mnemonic.nil? || worker.nil?
    end
  end
end
