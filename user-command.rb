# frozen_string_literal: true

class CoDoBo
  class UserCommand
    def initialize(bot, serverPrefix)
      @bot = bot
      @serverPrefix = serverPrefix
    end
    attr_reader :serverPrefix
    attr_reader :bot
    def run; end
  end
end
