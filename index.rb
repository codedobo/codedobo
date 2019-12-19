# frozen_string_literal: true

require 'discordrb'
require 'json'
require 'mysql2'
require_relative './lib/module.rb'
require_relative './lib/setup.rb'
require_relative './lib/bot.rb'
require_relative './lib/user_command.rb'
Dir[File.join('./modules/', '**/*.rb')].each do |file|
  puts "\u001b[36mIncluding #{file}..."
  require_relative file
  puts "\u001b[32mSuccessfully included #{file}!"
end
botModules = []
puts "\u001b[36mAdding modules..."
moduleClasses = ObjectSpace.each_object(Class).select do |c|
  c.included_modules.include? BotModule
end
moduleClasses.each do |botModuleClass|
  botModules.push(botModuleClass.new)
end
puts "\u001b[32mSuccessfully read modules!"

if ARGV.length != 1
  print 'Please enter a token: '
  botToken = gets.chomp
else
  botToken = ARGV[0]
end

puts "\u001b[36mStarting CoDoBo..."
bot = Discordrb::Bot.new token: botToken
puts "\u001b[36mConnecting to mysql..."
file = File.open 'database.json'
databaseData = JSON.load file
file.close
client = Mysql2::Client.new(host: databaseData['host'], username: databaseData['username'], password: databaseData['password'], database: databaseData['database'])
puts "\u001b[32mSuccessfully connected to mysql!"
coDoBo = CoDoBo.new(bot, client, botModules)
puts "\u001b[32mSuccessfully started CoDoBo!"
coDoBo.run
