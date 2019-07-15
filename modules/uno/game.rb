# frozen_string_literal: true

require_relative './uno-module.rb'
class UnoModule
  class MatchMaking
    class Game
      def initialize(bot, channel, language)
        @bot = bot
        @channel = channel
        @mode = :lobby
        @language = language
      end

      def ingame!(users)
        if users.length > 1
          @players = users
          Thread.new do
            30.downto(0) do |i|
              @channel.send_temporary_message format(@language.getJson(event.server.id)['matchmaking']['ingame-countdown'], s: i), 5
              sleep 1
            end
            check
            @mode = :ingame
          end
          true
        else
          false
        end
      end

      def lobby!(users)
        if users.length > 1
          @players = users
          Thread.new do
            30.downto(0) do |i|
              @channel.send_temporary_message format(@language.getJson(event.server.id)['matchmaking']['lobby-countdown'], s: i), 5
              sleep 1
            end
            check
            @mode = :lobby
          end
          true
        else
          false
        end
      end

      def lobby?
        @mode == :lobby
      end

      def ingame?
        @mode = :ingame
      end

      def leave(player)
        @players.delete(player)
        check
      end

      def check
        channel.delete if players.length < 2
      end

      def delete
        channel.delete
      end
      attr_reader :players
    end

    def initialize(bot, category, language)
      @bot = bot
      @category = category
      @games = []
      @privateGames = []
      @language = language
      createHub
      bot.discord.reaction_add do |event|
        react(event)
      end
    end

    def createHub
      hubChannel = @category.server.create_channel(@language.getJson(@category.server.id)['category']['hub']['name'], topic: @language.getJson(@category.server.id)['category']['hub']['topic'])
      hubChannel.category = @category
      @hubMessage = hubChannel.send_message(@language.getJson(@category.server.id)['messages']['hub'])
      @hubMessage.create_reaction('▶')
      @hubMessage.create_reaction('➕')
      @hubMessage.create_reaction('🔒')
      @hubMessage.pin
    end

    def deleteHub
      @hubMessage.channel.delete
    end

    def new
      game = Game.new(bot, category, privateRound, language)
      @games.push(game)
      game
    end

    def newPrivate
      game = Game.new(bot, category, privateRound, language)
      @privateGames.push(game)
      game
    end

    def get(user)
      @games.each do |game|
        game if game.players.includes? user
      end
    end

    def join(user, game)
      leave(user)
      game.join(user)
    end

    def random(_user)
      if !@games.empty?

      else
        new(false)
      end
    end

    def leave(user)
      @games.each do |game|
        game.leave(user)
      end
    end

    def exit
      puts 'Exiting game...'
      @hubMessage.channel.delete
      @games.each { |game| delete(game) }
      puts 'Successfully exited game!'
    end

    def delete(game)
      @game.delete
      @games.delete(game)
    end

    def react(event)
      if event.message.id == @hubMessage.id
        event.message.delete_reaction(event.user, event.emoji.name)
        case event.emoji.name
        when '▶'
          event.channel.send_message 'Play!'
        when '➕'
          event.channel.send_message 'New!'
        when '🔒'
          event.channel.send_message 'Private!'
        end
      end
    end
end
end
