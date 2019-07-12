# frozen_string_literal: true

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
            @moduleManager.userCommand(event)
          end
        end
      end
    end
  end
end
