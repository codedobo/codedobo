# frozen_string_literal: true

require_relative './main-module.rb'
require_relative '../../bot.rb'
class MainModule
  def userCommand(command, args, event)
    commandLanguage = @language.getJson(event.server.id)['commands']
    if commandLanguage['hello']['aliases'].include? command
      event.send_temporary_message format(commandLanguage['hello']['output'], u: event.author.username, v: CoDoBo.version, d: @@moduleDeveloper), 10
    elsif commandLanguage['modules']['aliases'].include? command
      moduleClasses = []
      @moduleManager.modules.each do |botModule|
        moduleClasses.push(botModule.class.name)
      end
      if args.empty?
        event.send_temporary_message format(commandLanguage['modules']['output'], c: @moduleManager.modules.length, m: moduleClasses.join(commandLanguage['modules']['delimiter'])), 10
      elsif args.length == 1
        moduleClasses = []
        @moduleManager.modules.each do |botModule|
          moduleClasses.push(botModule.class.name)
        end
        if moduleClasses.include? args[0]
          botModule = @moduleManager.modules[moduleClasses.index args[0]]
          botModule.help(event.user, event.channel)
        else
          event.send_temporary_message format(commandLanguage['help']['notexist'], u: event.author.username), 10
        end
      else
        event.send_temporary_message format(commandLanguage['help']['usage'], u: event.author.username), 10
      end
    end
  end

  def message(event)
    commandLanguage = @language.getJson(event.server.id)['commands']
    if commandLanguage['ping']['aliases'].include? event.content
      event.send_temporary_message format(commandLanguage['ping']['output'], u: event.author.username), 10
    end
  end

  def help(_user, channel)
    channel.send_temporary_message format(@language.getJson(channel.server.id)['help']), 10
  end
end
