# frozen_string_literal: true

class CodeDoBo
  # Command manager for the module manager
  class UserCommandManager
    #
    # Init new handler for user commands
    #
    # @param [CodeDoBo] bot
    # @param module_manager [CodeDoBo::ModuleManager]
    #
    def initialize(bot, module_manager)
      @module_manager = module_manager
      @bot = bot
      @multiple_commands = {}
      @multiple_modules = {}
      @language = CodeDoBo::Language.new module_manager.client, __dir__ + '/../language'

      @bot.discord.message do |event|
        run(event)
      end
    end

    #
    # Run an user command
    #
    # @param [Discordrb::Events::MessageEvent] event The send event
    #
    # @return [void]
    #
    def run(event)
      if @multiple_modules.include? [event.author.id, event.server.id]
        bot_module = @module_manager.get_module_by_string
        properties = @multiple_modules[[event.author.id, event.server.id]]
        if !bot_module.nil? && !properties[:m].include?(bot_module)
          handle_symbol_commands(properties[:m][bot_module], bot_module, properties[:c], properties[:a], event)
        else
          event << @language.get_json(event.server.id)['user']['multiple']['modules']['invalid']
          @multiple_commands.delete([event.author.id, event.server.id])
        end
        @multiple_modules.delete([event.author.id, event.server.id])
        return
      end
      if @multiple_commands.include? [event.author.id, event.server.id]
        properties = @multiple_commands[[event.author.id, event.server.id]]
        if properties[:s].map(&:to_s).include?(event.content)
          symbol = properties[:s][properties[:s].map(&:to_s).index(event.content)]
          properties[:ac].user_commands[symbol].call(properties[:c], properties[:a], event)
        else
          event << @language.get_json(event.server.id)['user']['multiple']['commands']['invalid']
        end
        @multiple_commands.delete([event.author.id, event.server.id])
        return
      end
      server_prefixes = @bot.server_prefix

      return unless event.content
      return unless server_prefixes.include? event.server.id

      return unless event.content.start_with?(server_prefixes[event.server.id])

      command_string = event.content[server_prefixes[event.server.id].length..-1]
      command_list = command_string.split(' ')

      if command_list.empty?
        handle_command('', nil, event)
      else
        handle_command(command_list[0], command_list[1..-1], event)
      end
    end

    # Stop the console manager
    # @return [void]
    def stop
      send_message "\u001b[36mStopping user command manager..."
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
    # @param modules_commands [Hash{CodeDoBo::AppModule=> Array(Symbol)}]
    #   used by CommandManager#handle_command
    # @param command_string [String]
    # @param args [Array(String)]
    # @param event [Discordrb::Events::MessageEvent]
    # @return [Object,nil]
    def handle_module_commands(modules_commands, command_string, args, event)
      return nil if modules_commands.empty?

      unless modules_commands.length == 1
        module_string_list = @module_manager.module_strings
        event << format(@language.get_json(event.server.id)['user']['multiple']['modules']['message'], m: module_string_list.join(@language.get_json(event.server.id)['user']['multiple']['modules']['delimiter']))
        @multiple_modules[[event.author.id, event.server.id]] = { m: modules_commands, c: command_string, a: args }
        return nil
      end
      current_module = modules_commands.keys.first
      symbols = modules_commands[current_module]
      handle_symbol_commands(symbols, current_module, command_string, args, event)
    end

    # Handle command from this array
    # @param symbols [Array(Symbol)]
    #   used by CommandManager#handle_module_commands
    # @param app_class [CodeDoBo::BotModule]
    # @param command_string [String]
    # @param args [Array(String)]
    # @param event [Discordrb::Events::MessageEvent]
    # @return [Object,nil]
    def handle_symbol_commands(symbols, app_class, command_string, args, event)
      return nil if symbols.empty?

      unless symbols.length == 1
        event << format(@language.get_json(event.server.id)['user']['multiple']['commands']['message'], m: symbols.join(@language.get_json(event.server.id)['user']['multiple']['commands']['delimiter']))
        @multiple_commands[[event.author.id, event.server.id]] = { s: symbols, c: command_string, a: args, ac: app_class }
        return nil
      end
      current_symbol = symbols.first if current_symbol.nil?
      return nil unless app_class.user_commands.keys.include? current_symbol

      app_class.user_commands[current_symbol].call(command_string, args, event)
    end

    # @param commands [Array(Symbol)]
    # @return [Symbol] current symbol
    def input_command(_event, commands)
      command_string_list = commands.map(&:to_s)
      input = ''
      until command_string_list.include? input
        send_message "\u001b[36mThis command uses multiple commands. Which command do you want to use? \r\n#{commands.join('][')}"
      end
      commands[command_string_list.index(input)]
    end

    # Print the prefix in the console
    # @return [void]
    def print_prefix
      out = "\u001b[37m$ \u001b[32mcodedobo-%<version>\u001b[33m:\u001b[34m%<user>\u001b[33m:\u001b[37m "
      version = CodeDoBo.version
      user = ENV['USERNAME']
      print format(out, version: version, user: user)
    end

    #
    # Send a message with the prefix
    #
    # @param [String] message
    # @param [Discordrb::] channel
    #
    # @return [void]
    #
    def send_message(message)
      puts "\u001b[37m[UserCommandManager] " + message + "\e[0m"
    end

    # @param error [StandardError]
    # @return [void]
    def print_error(error)
      send_message error.message + "\r\n"
    end
  end
end
