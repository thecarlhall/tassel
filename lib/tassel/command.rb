module Tassel
  class Command
    attr_accessor :label, :opts, :worker

    def validate
      raise ArgumentError, "label and worker must be set [#{self.inspect}]" if (label.nil? && mnemonic.nil?) || worker.nil?
    end
  end
end
