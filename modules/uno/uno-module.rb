# frozen_string_literal: true

require_relative '../module.rb'
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
  def createMatchMaking
    @matchMaking = UnoModule::MatchMaking.new
  end
  attr_reader :data
end
