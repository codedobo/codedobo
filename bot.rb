# frozen_string_literal: true

require_relative './console-command.rb'
class CoDoBo
  @@version = '0.5'
  def initialize(bot, client, modules)
    @bot = bot
    @client = client
    @moduleManager = CoDoBo::ModuleManager.new(client, modules)
    @consoleCommand = CoDoBo::ConsoleCommand.new(@moduleManager)
  end
  attr_reader :bot
  attr_reader :database
  def run
    puts 'Starting console bot...'
    Thread.new do
      @consoleCommand.run
    end
    puts 'Successfully started console bot!'
    bot.run
  end

  def self.version
    @@version
  end
end
