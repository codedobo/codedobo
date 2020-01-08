# frozen_string_literal: true

class CodeDoBo
  # A console command
  class ConsoleCommand
    # @param [Array(String)] aliases
    # @yield [command, args]
    def initialize(aliases, &block)
      @aliases = aliases
      @method = block
    end

    # @return [Array(String)]
    attr_accessor :aliases
    # @return [Proc]
    attr_accessor :method

    # @return [void]
    def call(command, args)
      method.call(command, args)
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
