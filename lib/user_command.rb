# frozen_string_literal: true

class CodeDoBo
  # A console command
  class UserCommand
    # @param [Array(String)] aliases
    # @yield [command, args, event]
    def initialize(aliases, &block)
      @aliases = aliases
      @method = block
    end

    # @return [Array{String}]
    attr_accessor :aliases
    # @return [Proc]
    attr_accessor :method

    # @return [void]
    def call(command, args, event)
      method.call(command, args, event)
    end

    
    #
    # Get all aliases by the language
    #
    # @param [String] language
    #
    # @return [Array(String)]
    #
    def language_aliases(language)
      aliases[language]
    end
  end
end
