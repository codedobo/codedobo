# frozen_string_literal: true

class UnoModule
  class Game
    def initialize(bot, category)
      @bot = bot
      @category = category
      @mode = :lobby
    end

    def start(users)
      if users.length > 1
        @players = users
        @mode = :ingame
      else
        false
      end
    end

    def ingame?
      @mode == :ingame
    end

    def lobby?
      @mode == :lobby
    end

    attr_reader :players
  end
end
