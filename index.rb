# frozen_string_literal: true

require 'discordrb'

require_relative 'modules/module.rb'
require_relative 'setup.rb'
require_relative 'console-command.rb'

Dir[File.join('.', '**/*.rb')].each do |file|
  puts "Including #{file}..."
  require_relative file
end
version = '0.0.1'

puts 'Starting bot...'

if ARGV.length != 1
  print 'Please enter a token: '
  botToken = gets.chomp
else
  botToken = ARGV[0]
end

bot = Discordrb::Bot.new token: botToken
class CoDoBo
  def initialize(bot, _modules)
    @bot = bot
    @consoleCommand = CoDoBo::ModuleManager.new(_modules)
  end
  attr_reader :bot
  def run
    puts 'Starting bot...'
    Thread.new do
      consoleCommand = ConsoleCommand.new(data, moduleManager)
      consoleCommand.run
    end
    puts 'Successfully started bot!'
    bot.run
  end
end
