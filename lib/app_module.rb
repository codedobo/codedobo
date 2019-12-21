# frozen_string_literal: true

class CoDoBo
  # Every module must be a child of this module
  module BotModule
    # @param app_class [CoDoBo::AppClass]
    # @param module_manager [CoDoBo::ModuleManager]
    def initialize(app_class, module_manager)
      @module_manager = module_manager
      @app_class = app_class
    end

    # Enable method.
    # @note Add this method to your module to do something
    #   if the module was enabled
    # @return [void]
    def on_enable; end

    # Disable method.
    # @note Add this method to your module to do something
    #   if the module was disable
    # @return [void]
    def on_disable; end

    # Set the prefix of the module for the send and error method
    # @return [String] prefix
    def prefix
      '[' + self.class.to_s + '] '
    end
    
    #
    # When the bot joined on a server
    #
    # @param [Discordrb::Server] server
    # @param [TrueClass] already If the bot was already on this server
    #
    # @return [void]
    def join(server, already); end

    # Send the message with the prefix
    # @return [void]
    def send_message(message)
      puts prefix + message + "\e[0m"
    end

    # Send the method in red with the prefix
    # @return [void]
    def error(message)
      puts prefix + "\e[31m" + message + "\e[0m"
    end

    # Set the help method to get this via module <Module>
    # @param _args [Array(String)] arguments
    # @return [String]
    def help(_args)
      error 'No help for this module!'
    end
    # @return [CoDoBo::AppClass]
    attr_reader :app_class
  end
end
