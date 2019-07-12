# frozen_string_literal: true

require_relative './main-module.rb'
require_relative '../../bot.rb'
class MainModule
  def userCommand(command, _args, event)
    if @language.get(event.server.id)['commands']['hello']['aliases'].include? command
      event.send_temporary_message format(@language.get(event.server.id)['commands']['hello']['output'], u: event.author.username, v: CoDoBo.version), 10
    end
  end

  def message(event)
    if @language.get(event.server.id)['commands']['ping']['aliases'].include? event.content
      event.send_temporary_message @language.get(event.server.id)['commands']['ping']['output'] % event.author.username, 10
    end
  end
end
