# frozen_string_literal: true

class CPGUI
  # Every CPGUI module has this class to manage the module with
  # for example the enable
  class AppClass
    # @param properties [Hash(String, Object)]
    # @param main_class [Class(CPGUI::AppModule)]
    # @param module_manager [CPGUI::ModuleManager]
    # @param enable [Boolean]
    def initialize(properties, main_class, module_manager, enable = true)
      @properties = properties
      @app_module = main_class.new(self, module_manager)
      @module_manager = module_manager
      @enabled = false
      @commands = {}
      enable! if enable
    end
    # @return [Hash(String, Object)]
    attr_reader :properties
    # @return [CPGUI::AppModule]
    attr_reader :app_module

    # Register a command for the CPGUI::CommandManager
    # @param symbol [Symbol]
    # @param aliases [Array(String)]
    # @yield [command, args]
    # @yieldparam command [String]
    # @yieldparam args [Array(String)]
    # @return [void]
    def register(symbol, aliases, &block)
      @commands[symbol] = Command.new(aliases) do |*params|
        block.call(*params)
      end
    end

    # Unregister a command for the CPGUI::CommandManager
    # @param symbol [Symbol]
    # @return [void]
    def unregister(symbol)
      @commands.delete(symbol)
    end

    # @return [Hash(Symbol,CPGUI::Command)]
    attr_reader :commands

    # Enable/Disable the module
    # @return [void]
    def enabled!(enable = true)
      last = @enabled
      if enable
        @enabled = true
        app_module.on_enable unless last
      else
        @enabled = false
        app_module.on_disable if last
      end
    end

    alias enable! enabled!

    # Check if the module is enabled
    # @return [true, false]
    def enabled?
      @enabled
    end

    alias enable? enabled?

    # Disable/Enable the module
    # @return [void]
    def disabled!(disable = true)
      last = @enabled
      if disable
        @enabled = false
        app_module.on_disable if last
      else
        @enabled = true
        app_module.on_enable unless last
      end
    end

    alias disable! disabled!

    # Check if module is disabled
    # @return [true, false]
    def disabled?
      !@enabled
    end

    alias disable? disabled?

    # Disable and enable the module!
    # @return [void]
    def reload
      disable!
      enable!
    end

    attr_reader :module_manager
  end
end
