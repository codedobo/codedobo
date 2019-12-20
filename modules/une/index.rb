# frozen_string_literal: true

require_relative './user-commands.rb'
require_relative './game.rb'
require_relative './setup.rb'
# Uno module for the codobo
class UnoModule
  include BotModule
  def self.module_version
    '0.5'
  end

  def start(client, module_manager)
    puts "\u001b[36mStarting uno module..."
    @client = client
    @module_manager = module_manager
    @language = BotModule::Language.new __dir__ + '/language', @client
    setup
    @module_manager.bot.discord.message do |event|
      message(event)
    end
    puts "\u001b[32mSuccessfully started uno module!"
  end

  def console_command(command, _args)
    puts "\u001b[96mRunning uno@#{module_version} module!" if command == 'uno'
    true if command == 'uno'
  end

  def match_making
    @match_making&.each do |_key, value|
      value.exit
    end
    @match_making = {}
    @client.query('SELECT * FROM `uno`').each do |row|
      next if row['CATEGORY'].nil?
      next unless @module_manager.bot.discord.servers.key? row['SERVERID']

      channel = @module_manager.bot.discord.channel(row['CATEGORY'])
      bot = @module_manager.bot
      channel_match_making = UnoModule::MatchMaking.new(bot, channel, @language)
      @match_making[row['SERVERID'].to_i] = channel_match_making
    end
  end

  def exit
    @match_making.each do |_key, value|
      value.exit
    end
  end
  attr_reader :data
end
