require 'logger'
require 'tassel/main'

module Tassel
  # Convenience method for call Tassel::Main.register_command
  #def self.register_command(worker, &block)
  #  Tassel::Main.register_command(worker, &block)
  #end

  class << self
    def logger
      @@logger ||= Logger.new(File.join(@config.tassel_home, 'tassel.log'))
    end
  end
end
