# frozen_string_literal: true

class CodeDoBo
  # Command manager for the module manager
  class ConsoleCommandManager
    # @param module_manager [CodeDoBo::ModuleManager]
    def initialize(bot, module_manager)
      @module_manager = module_manager
      @bot = bot
    end

    # Run the console manager
    # @return [void]
    def run
      send_message "\u001b[36mStarting console..."
      @run = true
      input while @run
    end

    # Print prefix and handle the input of the console
    # @return [void]
    def input
      print_prefix
      handle_input
    rescue StandardError, Interrupt => e
      print_error(e.full_message) if e.is_a? StandardError
      puts "\r\n"
      send_message "\u001b[36mExiting application... \r\n\r\n"
      @bot.stop
      exit
    end

    # Handle input
    # @return [void]
    def handle_input
      command = split_input(STDIN.gets.chomp)
      return false if command.nil?

      exist = handle_command(command[:prefix], command[:args])
      send_message "\u001b[31mCommand not found!" unless exist
    end

    # Split the input in command and arguments
    # @param [String] input
    # @return [Hash] :prefix and :args
    def split_input(input)
      input_list = input.split(' ')
      return if input_list.empty?

      command_prefix = input_list[0]
      command_args = input_list[1..-1]
      { prefix: command_prefix, args: command_args }
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
    # @return [Object,nil]
    def handle_command(command_string, args)
      modules_commands = {}
      @module_manager.modules.each do |app_class|
        commands = app_class.console_commands.select do |_symbol, command|
          return false if command.aliases.nil?

          true if command.aliases.include? command_string
        end
        permit = app_class.enabled? && !commands.empty?
        modules_commands[app_class] = commands.keys if permit
      end
      handle_module_commands(modules_commands, command_string, args)
    end

    # Handle command from this array
    # @param modules_commands [Hash{CodeDoBo::BotModule=> Array(String)}]
    #   used by CommandManager#handle_command
    # @param command_string [String]
    # @param args [Array(String)]
    # @return [Object,nil]
    def handle_module_commands(modules_commands, command_string, args)
      return nil if modules_commands.empty?

      unless modules_commands.length == 1
        current_module = input_module(modules_commands.keys)
      end
      current_module = modules_commands.keys.first if current_module.nil?
      symbols = modules_commands[current_module]
      handle_symbol_commands(symbols, current_module, command_string, args)
    end

    # Handle command from this array
    # @param symbols [Array(Symbol)]
    #   used by CommandManager#handle_module_commands
    # @param app_class [CodeDoBo::AppModule]
    # @param command_string [String]
    # @param args [Array(String)]
    # @return [Object,nil]
    def handle_symbol_commands(symbols, app_class, command_string, args)
      return nil if symbols.empty?

      current_symbol = input_command(symbols) unless symbols.length == 1
      current_symbol = symbols.first if current_symbol.nil?
      return nil unless app_class.console_commands.keys.include? current_symbol

      app_class.console_commands[current_symbol].call(command_string, args)
      true
    end

    # @param modules [Array(CodeDoBo::AppClass)]
    # @return [CodeDoBo::AppClass] current selected module
    def input_module(modules)
      module_string_list = @module_manager.module_strings
      input = ''
      until module_string_list.include? input
        send_message "\u001b[36mThis command uses multiple modules. Which module do you want to use? \r\n#{modules.join(', ')}"
        input = STDIN.gets.chomp
      end
      modules[module_string_list.index(input)]
    end

    # @param commands [Array(Symbol)]
    # @return [Symbol] current symbol
    def input_command(commands)
      command_string_list = commands.map(&:to_s)
      input = ''
      until command_string_list.include? input
        send_message "\u001b[36mThis command uses multiple commands. Which command do you want to use? \r\n#{commands.join(', ')}"
        input = STDIN.gets.chomp
      end
      commands[command_string_list.index(input)]
    end

    # Print the prefix in the console
    # @return [void]
    def print_prefix
      out = "\u001b[37m$ \u001b[32mcodedobo-%{version}\u001b[33m:\u001b[34m%{user}\u001b[33m:\u001b[37m "
      version = CodeDoBo.version
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

    # @param error [String]
    # @return [void]
    def print_error(error)
      send_message "\u001b[31m" + error + "\r\n"
    end
  end
end
