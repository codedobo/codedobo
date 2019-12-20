# frozen_string_literal: true

require_relative './index.rb'
class UnoModule
  # MatchMaking is a class which handle the uno system!
  class MatchMaking
    class Game
      # Every team has own game channels!
      class GameChannel
        def initialize(player, category, language, _gane)
          @player = player
          @category = category
          @language = language
          @channel = category.create_channel
          @game = game
          @messages = []
          timeOut
        end

        def exit; end

        def send_message(content, tts = false, embed = nil, pin = false)
          message = @channel.send_message(content, tts, embed)
          @messages.push(message)
          @channel.pin(message) if pin
        end

        def timeOut
          @timeOut = 0
          Thread.new do
            @timeOut.upto(10) do
              sleep 1
            end
            @game.match_making.leave(player)
          end
        end

        def delete_messages
          @messages.each do |message|
            message.delete
            @messages.delete(message)
          end
        end
      end
      # A card is a game element in uno
      class Card
        def initialize(json)
          @properties = json
        end

        def set?(card)
          my_prop = @properties
          if (card.groups.before & my_prop.groups.after).empty?
            true
          else
            false
          end
        end
        attr_accessor :properties
      end

      def initialize(match_making, category, language)
        @category = category
        @mode = :lobby
        @language = language
        @tokens = []
        channel = @category.server.create_channel(@language.getJson(@category.server.id)['category']['lobby']['name'], topic: @language.getJson(@category.server.id)['category']['lobby']['topic'])
        channel.category = @category
        @message = channel.send_message(@language.getJson(@category.server.id)['messages']['lobby'])
        @message.create_reaction('✖')
        @message.pin
        @players = []
        @userChannels = {}
        channel.server.roles.each do |role|
          channel.define_overwrite(role, Discordrb::Permissions.new, Discordrb::Permissions.new(%i[read_messages add_reactions send_messages]))
        end
        match_making.bot.discord.reaction_add do |event|
          react(event)
        end
      end

      def ingame!
        if @players.length > 1
          Thread.new do
            30.downto(0) do |i|
              @message.channel.send_message format(@language.getJson(@message.channel.server.id)['messages']['ingame-countdown'], s: i)
              sleep 1
            end
            @userChannels.each(&:delete)
            @userChannels.clear
            @players.each do |player|
              channel = @category.server.create_channel(@language.getJson(@category.server.id)['category']['lobby']['name'], topic: @language.getJson(@category.server.id)['category']['lobby']['topic'])
              channel.category = @category
              @message = channel.send_message(@language.getJson(@category.server.id)['messages']['lobby'])
              @message.create_reaction('✖')
              @message.pin
              @userChannels[player]
            end
            @mode = :ingame
          end
        else
          Thread.new do
            30.downto(0) do |i|
              @message.channel.send_message format(@language.getJson(event.server.id)['messages']['ingame-close'], s: i)
              if players.length > 1
                ingame!
                break
              end
              sleep 1
            end
          end
        end
      end

      def lobby!
        if @players.length > 1
          Thread.new do
            30.downto(0) do |i|
              @message.channel.send_message format(@language.getJson(event.server.id)['messages']['lobby-countdown'], s: i)
              sleep 1
            end
            @userChannels.each(&:delete)
            @mode = :lobby
          end
        else
          Thread.new do
            30.downto(0) do |i|
              @message.channel.send_message format(@language.getJson(event.server.id)['messages']['lobby-close'], s: i)
              if players.length > 1
                lobby!
                break
              end
              sleep 1
            end
          end
        end
      end

      def lobby?
        @mode == :lobby
      end

      def ingame?
        @mode = :ingame
      end

      def join(player, token = nil)
        unless @players.include? player
          @players.push(player)
          @tokens.delete(token) unless token.nil?
          @message.channel.send_message format(@language.getJson(@category.server.id)['messages']['join'], p: player.name)
          @message.channel.define_overwrite player, Discordrb::Permissions.new(%i[read_messages add_reactions send_messages]), Discordrb::Permissions.new
          ingame!
        end
      end

      def leave(player)
        if @players.include? player
          @players.delete(player)
          @message.channel.send_message format(@language.getJson(@category.server.id)['messages']['leave'], p: player.name)
          @message.channel.define_overwrite player, Discordrb::Permissions.new, Discordrb::Permissions.new(%i[read_messages add_reactions send_messages])
          close?
        end
      end

      def min?
        true if players.length > 1
      end

      def close?
        true if players.empty?
      end

      def delete
        @userChannels.each do |_key, value|
          value.delete
        end
        @message.channel.delete
      end

      def react(event)
        if event.message.id == @message.id
          event.message.delete_reaction(event.user, event.emoji.name)
          case event.emoji.name
          when '✖'
            @match_making.leave(event.user)
          end
        end
      end
      attr_reader :tokens
      attr_reader :players
      attr_reader :userChannels
    end
    @token = []

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

    def create(player)
      leave(player)
      game = Game.new(self, @category, @language)
      @games.push(game)
      game.join(player)
      game
    end

    def createPrivate
      game = Game.new(self, @category, @language)
      @privateGames.push(game)
      game
    end

    def get(player)
      @games.each do |game|
        game if game.players.includes? player
      end
    end

    def join(player, game)
      leave(player)
      game.join(player)
    end

    def random(player)
      leave(player)
      if !@games.empty?
        game = @games.sample
        join(player, game)
        game
      else
        create(player)
      end
    end

    def leave(player)
      @games.each do |game|
        game.leave(player)
        delete(game) if game.close?
      end
    end

    def exit
      @hubMessage.channel.delete
      @games.each { |game| delete(game) }
    end

    def delete(game)
      game.delete
      @games.delete(game)
    end

    def react(event)
      if event.message.id == @hubMessage.id
        event.message.delete_reaction(event.user, event.emoji.name)
        case event.emoji.name
        when '▶'
          random(event.user)
        when '➕'
          event.channel.send_message 'New!'
        when '🔒'
          event.channel.send_message 'Private!'
        end
      end
    end

    def newToken(game)
      isUnique = true
      token = nil
      until isUnique
        o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
        token = (0...50).map { o[rand(o.length)] }.join
        isUnique = true
        @games.each do |current_game|
          isUnique = false if current_game.tokens.include? token
        end
      end
      game.tokens.push(token)
      token
    end
    attr_reader :bot
  end
end
