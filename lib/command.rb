# frozen_string_literal: true

class CoDoBo
  # A console command
  class Command
    # @param [Hash<String, String>] aliases Hash<ServerID, Aliases> 
    # @yield [command, args]
    def initialize(aliases, &block)
      @aliases = aliases
      @method = block
    end

    # @return [Hash<String, String>] Hash<ServerID, Aliases>
    attr_accessor :aliases
    # @return [Proc]
    attr_accessor :method

    # @return [void]
    def call(command, args)
      method.call(command, args)
    end
  end
end
