# frozen_string_literal: true

class CPGUI
  # Every module must be a child of this module
  module AppModule
    # @param app_class [CPGUI::AppClass]
    # @param module_manager [CPGUI::ModuleManager]
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

    # Handle console commands.
    # @note Add this method to your module to do something
    #   if a command was entered
    # @deprecated Use the method {AppClass.register} instead!
    def console; end

    # Set the prefix of the module for the send and error method
    # @return [String] prefix
    def prefix
      '[' + self.class.to_s + '] '
    end

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
    # @return [CPGUI::AppClass]
    attr_reader :app_class
  end
end
