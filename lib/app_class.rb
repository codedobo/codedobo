# frozen_string_literal: true

class CoDoBo
  # Every CoDoBo module has this class to manage the module with
  # for example the enable
  class BotClass
    # @param properties [Hash(String, Object)]
    # @param main_class [Class(CoDoBo::AppModule)]
    # @param module_manager [CoDoBo::ModuleManager]
    # @param enable [Boolean]
    def initialize(properties, main_class, module_manager, enable = true)
      @properties = properties
      @app_module = main_class.new(self, module_manager)
      @module_manager = module_manager
      @enabled = false
      @user_commands = {}
      @console_commands = {}
      enable! if enable
    end
    # @return [Hash(String, Object)]
    attr_reader :properties
    # @return [CoDoBo::BotModule]
    attr_reader :app_module

    # Register a user command for the CoDoBo::UserCommandManager
    # @param symbol [Symbol]
    # @param aliases [Hash<String, String>] Hash<ServerID, Aliases>
    # @yield [command, args]
    # @yieldparam command [String]
    # @yieldparam args [Array(String)]
    # @return [void]
    def register_user_cmd(symbol, aliases, &block)
      @user_commands[symbol] = Command.new(aliases) do |*params|
        block.call(*params)
      end
    end

    # Unregister a user command for the CoDoBo::UserCommandManager
    # @param symbol [Symbol]
    # @return [void]
    def unregister_user_cmd(symbol)
      @user_commands.delete(symbol)
    end

    # @return [Hash(Symbol,CoDoBo::Command)]
    attr_reader :user_commands

    # Register a console command for the CoDoBo::ConsoleCommandManager
    # @param symbol [Symbol]
    # @param aliases [Array(String)]
    # @yield [command, args]
    # @yieldparam command [String]
    # @yieldparam args [Array(String)]
    # @return [void]
    def register_console_cmd(symbol, aliases, &block)
      @console_commands[symbol] = Command.new(aliases) do |*params|
        block.call(*params)
      end
    end

    # Unregister a console command for the CoDoBo::ConsoleCommandManager
    # @param symbol [Symbol]
    # @return [void]
    def unregister_console_cmd(symbol)
      @user_commands.delete(symbol)
    end

    # @return [Hash(Symbol,CoDoBo::Command)]
    attr_reader :console_commands

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
