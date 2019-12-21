# frozen_string_literal: true

class CoDoBo
  # Command manager for the module manager
  class UserCommandManager
    # @param module_manager [CoDoBo::ModuleManager]
    def initialize(bot, module_manager)
      @module_manager = module_manager
      @bot = bot

      @bot.discord.message do |event|
        run(event)
      end
    end

    # The prefix of the console manager
    # @return [String]
    def prefix
      @language.get('console', 'prefix')
    end

    #
    # Run an user command
    #
    # @param [Discordrb::Events::MessageEvent] event The send event
    #
    # @return [<Type>] <description>
    #
    def run(event)
      if @bot.server_prefix
        if @bot.server_prefix.include? event.server.id
          if event.content.start_with?(@bot.server_prefix[event.server.id])
            command_string = event.content[@bot.server_prefix[event.server.id].length..-1]
            command_list = command_string.split(' ')

            unless command_list.empty?
              command = command_list[0]
              command_args = command_list[1..-1]
              handle_command(command, command_args, event)
            else
              handle_command("", nil, event)
            end
          end
        end
      end
    end

    # Stop the console manager
    # @return [void]
    def stop
      send_message "\u001b[36mStopping console..."
      @run = false
    end

    # Test if console manager is running
    # @return [Boolean]
    def run?
      @run
    end

    # Handle command on every module
    # @param command_string [String]
    # @param args [Array(String)]
    # @param event [Discordrb::Events::MessageEvent]
    # @return [Object,nil]
    def handle_command(command_string, args, event)
      modules_commands = {}
      @module_manager.modules.each do |app_class|
        
        commands = app_class.user_commands.select do |_symbol, command|
          return false if command.aliases.nil?

          true if command.aliases.include? command_string
        end
        permit = app_class.enabled? && !commands.empty?
        modules_commands[app_class] = commands.keys if permit
      end
      handle_module_commands(modules_commands, command_string, args, event)
    end

    # Handle command from this array
    # @param modules_commands [Hash(CoDoBo::AppModule, Array(String))]
    #   used by CommandManager#handle_command
    # @param command_string [String]
    # @param args [Array(String)]
    # @param event [Discordrb::Events::MessageEvent]
    # @return [Object,nil]
    def handle_module_commands(modules_commands, command_string, args,event)
      return nil if modules_commands.empty?

      unless modules_commands.length == 1
        current_module = input_module(modules_commands.keys)
      end
      current_module = modules_commands.keys.first if current_module.nil?
      symbols = modules_commands[current_module]
      handle_symbol_commands(symbols, current_module, command_string, args,event)
    end

    # Handle command from this array
    # @param symbols [Array(Symbol)]
    #   used by CommandManager#handle_module_commands
    # @param app_class [CoDoBo::AppModule]
    # @param command_string [String]
    # @param args [Array(String)]
    # @param event [Discordrb::Events::MessageEvent]
    # @return [Object,nil]
    def handle_symbol_commands(symbols, app_class, command_string, args, event)
      return nil if symbols.empty?

      current_symbol = input_command(symbols) unless symbols.length == 1
      current_symbol = symbols.first if current_symbol.nil?
      return nil unless app_class.commands.keys.include? current_symbol

      @module_manager.user_command(command_string, args,event)
    end

    # @param modules [Array(CoDoBo::AppClass)]
    # @return [CoDoBo::AppClass] current selected module
    def input_module(modules)
      module_string_list = @module_manager.module_strings
      input = ''
      until module_string_list.include? input
        send_message "\u001b[36mThis command uses multiple modules. Which module do you want to use? \r\n#{modules.join(", ")}"
        input = gets.chomp
      end
      modules[module_string_list.index(input)]
    end

    # @param commands [Array(Symbol)]
    # @return [Symbol] current symbol
    def input_command(commands)
      command_string_list = commands.map(&:to_s)
      input = ''
      until command_string_list.include? input
        send_message "\u001b[36mThis command uses multiple commands. Which command do you want to use? \r\n#{commands.join(", ")}"
        input = gets.chomp
      end
      commands[command_string_list.index(input)]
    end

    # Print the prefix in the console
    # @return [void]
    def print_prefix
      out = "\u001b[37m$ \u001b[32mcodobo-%{version}\u001b[33m:\u001b[34m%{user}\u001b[33m:\u001b[37m "
      version = CoDoBo.version
      user = ENV['USERNAME']
      print format(out, version: version, user: user)
    end

    #
    # Send a message with the prefix
    #
    # @param [String] message
    #
    # @return [void]
    #
    def send_message(message)
      puts "\u001b[36m[ConsoleCommandManager] " + message + "\e[0m"
    end

    # @param error [StandardError]
    # @return [void]
    def print_error(error)
      send_message error.message + "\r\n"
    end
  end
end
