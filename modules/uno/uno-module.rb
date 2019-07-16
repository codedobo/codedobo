# frozen_string_literal: true

require_relative '../../module.rb'
require_relative './user-commands.rb'
require_relative './game.rb'
class UnoModule
  include BotModule
  @@moduleVersion = '0.5'
  def start(client, moduleManager)
    puts 'Starting uno module...'
    @client = client
    @moduleManager = moduleManager
    @language = BotModule::Language.new 'uno', @client
    setup
    @moduleManager.bot.discord.message do |event|
      message(event)
    end
    puts 'Successfully started uno module!'
  end

  def consoleCommand(command, _args)
    if command == 'uno'
      puts "Running uno@#{@@moduleVersion} module!"
      true
    end
  end

  def matchMaking
    @matchMaking = {}
    @client.query('SELECT * FROM `uno`').each do |row|
      next if row['CATEGORY'].nil?
      next unless @moduleManager.bot.discord.servers.key? row['SERVERID']

      @matchMaking[row['SERVERID'].to_i] = UnoModule::MatchMaking.new(@moduleManager.bot, @moduleManager.bot.discord.channel(row['CATEGORY']), @language)
    end
  end

  def exit
    @matchMaking.each do |_key, value|
      value.exit
    end
  end
  attr_reader :data
end
