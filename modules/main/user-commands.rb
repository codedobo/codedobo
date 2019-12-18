# frozen_string_literal: true

require_relative './index.rb'
require_relative '../../bot.rb'
class MainModule
  def user_command(command, args, event)
    command_language = @language.getJson(event.server.id)['commands']
    if command_language['hello']['aliases'].include? command
      event.send_temporary_message format(command_language['hello']['output'], u: event.author.username, v: CoDoBo.version, d: @@moduleDeveloper), 10
    elsif command_language['modules']['aliases'].include? command
      moduleClasses = []
      @module_manager.modules.each do |botModule|
        moduleClasses.push(botModule.class.name)
      end
      if args.empty?
        event.send_temporary_message format(command_language['modules']['output'], c: @module_manager.modules.length, m: moduleClasses.join(command_language['modules']['delimiter'])), 10
      elsif args.length == 1
        moduleClasses = []
        @module_manager.modules.each do |botModule|
          moduleClasses.push(botModule.class.name)
        end
        if moduleClasses.include? args[0]
          botModule = @module_manager.modules[moduleClasses.index args[0]]
          botModule.help(event.user, event.channel)
        else
          event.send_temporary_message format(command_language['help']['notexist'], u: event.author.username), 10
        end
      else
        event.send_temporary_message format(command_language['help']['usage'], u: event.author.username), 10
      end
    end
  end

  def message(event)
    command_language = @language.getJson(event.server.id)['commands']
    if command_language['ping']['aliases'].include? event.content
      event.send_temporary_message format(command_language['ping']['output'], u: event.author.username), 10
    end
  end

  def help(_user, channel)
    channel.send_temporary_message format(@language.getJson(channel.server.id)['help']), 10
  end
end
