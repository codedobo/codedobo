# frozen_string_literal: true

require_relative './bot.rb'
class CoDoBo
  class UserCommand
    def initialize(bot, moduleManager)
      @bot = bot
      @moduleManager = moduleManager

      @bot.discord.message do |event|
        run(event)
      end
    end
    attr_reader :bot
    def run(event)
      if bot.serverPrefix
        if bot.serverPrefix.include? event.server.id
          if event.content.start_with?(bot.serverPrefix[event.server.id])
            commandString = event.content[bot.serverPrefix[event.server.id].length..-1]
            commandList = commandString.split(' ')

            unless commandList.empty?
              command = commandList[0]
              commandArgs = commandList[1..-1]
              @moduleManager.userCommand(command, commandArgs, event)
            end
          end
        end
      end
    end
  end
end
