# frozen_string_literal: true

require_relative './main-module.rb'
require_relative '../../bot.rb'
class MainModule
  def userCommand(command, _args, event)
    commandLanguage = @language.get(event.server.id)['commands']
    if commandLanguage['hello']['aliases'].include? command
      event.send_temporary_message format(commandLanguage['hello']['output'], u: event.author.username, v: CoDoBo.version), 10
    elsif commandLanguage['modules']['aliases'].include? command
      moduleClasses = []
      @moduleManager.modules.each do |botModule|
        moduleClasses.push(botModule.class.name)
      end
      event.send_temporary_message format(commandLanguage['modules']['output'], c: @moduleManager.modules.length, m: moduleClasses.join(commandLanguage['modules']['delimiter'])), 10
    end
  end

  def message(event)
    commandLanguage = @language.get(event.server.id)['commands']
    if commandLanguage['ping']['aliases'].include? event.content
      event.send_temporary_message format(commandLanguage['ping']['output'], u: event.author.username), 10
    end
  end
end
