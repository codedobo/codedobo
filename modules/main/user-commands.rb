# frozen_string_literal: true

require_relative './index.rb'
class MainModule
  # @deprecated
  def deprecated_method(command, _args, event)
    command_language = @language.get_json(event.server.id)['commands']
    if command_language['hello']['aliases'].include? command
    elsif command_language['modules']['aliases'].include? command
    end
  end

  def register_user_commands
    register_hello_command
    register_module_command
  end

  def register_hello_command
    @app_class.register_user_cmd(:hello, ['', 'hello', 'hi', 'info']) do |_command, _args, event|
      event << format(@language.get_json(event.server.id)['commands']['hello']['output'], u: event.author.username, v: CoDoBo.version, d: CoDoBo.developer)
    end
  end

  def register_module_command
    @app_class.register_user_cmd(:new, %w[modules module mod m]) do |_command, args, event|
      command_language = @language.get_json(event.server.id)['commands']['modules']
      if args.empty?
        event << format(command_language['output'], c: @module_manager.modules.length, m: @module_manager.module_strings.join(command_language['delimiter']))
      elsif args.length == 1
        bot_module = @module_manager.get_module_by_string(args[0])
        puts bot_module.class.to_s
        if bot_module
          bot_module.app_module.help(event.user, event.channel)
        else
          event << format(command_language['notexist'], u: event.author.username, m: args[0])
        end
      else
        event << format(command_language['usage'], u: event.author.username)
      end
    end
  end

  # def message(event)
  #   command_language = @language.get_json(event.server.id)['commands']
  #   if command_language['ping']['aliases'].include? event.content
  #     event << format(command_language['ping']['output'], u: event.author.username)
  #   end
  # end

  def help(_user, channel)
    command_language = @language.get_json(channel.server.id)['commands']['help']
    channel.send_embed do |embed|
       embed.title = command_language['title']
       embed.description = command_language['description']
       embed.timestamp = Time.now
    end
  end
end
