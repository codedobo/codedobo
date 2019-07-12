# frozen_string_literal: true

require_relative './main-module.rb'
class MainModule
  def userCommand(command, _args, event)
    language = @moduleManager.getLanguage(event.server.id, 'main')
    if language['commands']['hello']['aliases'].include? command
      event.send_temporary_message language['commands']['hello']['output'] % event.author.username, 10
    end
  end
end
