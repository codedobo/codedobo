# frozen_string_literal: true

require_relative './main-module.rb'
class MainModule
  def userCommand(command, _args, event)
    language = @moduleManager.getLanguage(event.server.id, 'main')
    if language['commands']['hello']['aliases'].include? command
      event.send_temporary_message language['commands']['hello']['output'] % event.author.username, 10
    elsif language['commands']['ping']['aliases'].include? command
      event.send_temporary_message language['commands']['ping']['output'] % event.author.username, 10
    end
  end
end
