module Tassel
  module DSL
    # Register a command. The command will be automatically displayed in the
    # menu.
    def register_command(options => {}, &block)
      raise ArgumentError, 'Must provide `label` and `mnemonic`' unless options.has_key?('label') && options.has_key?('mnemonic')

      command = Command.new(options, &block)

      @command_handlers_by_label ||= {}
      @command_handlers_by_mnemonic ||= {}

      @command_handlers_by_label[label] = command
      @command_handlers_by_mnemonic[mnemonic] = command
    end
  end
end
