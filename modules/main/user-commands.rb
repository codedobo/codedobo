# frozen_string_literal: true

require_relative './index.rb'
class MainModule
  # @deprecated
  def deprecated_method(command, args, event)
    command_language = @language.get_json(event.server.id)['commands']
    if command_language['hello']['aliases'].include? command
    elsif command_language['modules']['aliases'].include? command
      moduleClasses = []
      @module_manager.modules.each do |botModule|
        moduleClasses.push(botModule.class.name)
      end
      if args.empty?
        event << format(command_language['modules']['output'], c: @module_manager.modules.length, m: moduleClasses.join(command_language['modules']['delimiter']))
      elsif args.length == 1
        moduleClasses = []
        @module_manager.modules.each do |botModule|
          moduleClasses.push(botModule.class.name)
        end
        if moduleClasses.include? args[0]
          botModule = @module_manager.modules[moduleClasses.index args[0]]
          botModule.help(event.user, event.channel)
        else
          event << format(command_language['modules']['notexist'], u: event.author.username, m: args[0])
        end
      else
        event << format(command_language['modules']['usage'], u: event.author.username)
      end
    end
  end

  def register_user_commands
    register_hello_command
    register_new_command
  end

  def register_hello_command
    puts @language.get_language_hash("commands","hello","aliases")
    @app_class.register_user_cmd(:hello, @language.get_language_array("commands", "hello","aliases")) do |command, args, event|
      event << format(@language.get_json(event.server.id)['commands']['hello']['output'], u: event.author.username, v: CoDoBo.version, d: CoDoBo.developer)
    end
  end

  def register_new_command
    puts @language.get_language_hash("commands","hello","aliases")
    @app_class.register_user_cmd(:new, @language.get_language_array("commands", "hello","aliases")) do |command, args, event|
      event << format(@language.get_json(event.server.id)['commands']['hello']['output'], u: event.author.username, v: CoDoBo.version, d: CoDoBo.developer)
    end
  end

  def message(event)
    command_language = @language.get_json(event.server.id)['commands']
    if command_language['ping']['aliases'].include? event.content
      event << format(command_language['ping']['output'], u: event.author.username)
    end
  end

  def help(_user, channel)
    channel.send_message format(@language.get_json(channel.server.id)['help','message'])
  end
end
