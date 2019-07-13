# frozen_string_literal: true

require_relative './uno-module.rb'
class UnoModule
  def userCommand(command, args, event)
    commandLanguage = @language.getJson(event.server.id)['commands']
    if commandLanguage['uno']['aliases'].include? command
      if !args.empty?
        case args[0]
        when *commandLanguage['help']['aliases']
          if event.user.owner?
            event.send_temporary_message format(commandLanguage['help']['output'], u: event.author.username, v: CoDoBo.version), 10
          else
            event.send_temporary_message format(commandLanguage['help']['nopermission'], u: event.author.username, v: CoDoBo.version), 10
          end
        else
          event.send_temporary_message format(commandLanguage['notexist'], u: event.author.username, v: CoDoBo.version), 10
        end
      else
        event.send_temporary_message format(commandLanguage['uno']['output'], u: event.author.username, v: CoDoBo.version), 10
    end
  end
  end

  def message(event); end
end
