# frozen_string_literal: true

require 'discordrb'
require 'json'
require 'mysql2'
Dir[File.join('./modules/', '**/*.rb')].each do |file|
  puts "Including #{file}..."
  require_relative file
  puts "Successfully included #{file}!"
end
require_relative './module.rb'
require_relative './setup.rb'
require_relative './bot.rb'
require_relative './user_command.rb'
botModules = []
puts 'Adding modules...'
moduleClasses = ObjectSpace.each_object(Class).select do |c|
  c.included_modules.include? BotModule
end
moduleClasses.each do |botModuleClass|
  botModules.push(botModuleClass.new)
end
puts 'Successfully read modules!'

if ARGV.length != 1
  print 'Please enter a token: '
  botToken = gets.chomp
else
  botToken = ARGV[0]
end

puts 'Starting CoDoBo...'
bot = Discordrb::Bot.new token: botToken
puts 'Connecting to mysql...'
file = File.open 'database.json'
databaseData = JSON.load file
file.close
client = Mysql2::Client.new(host: databaseData['host'], username: databaseData['username'], password: databaseData['password'], database: databaseData['database'])
puts 'Successfully connected to mysql!'
coDoBo = CoDoBo.new(bot, client, botModules)
puts 'Successfully started CoDoBo!'
coDoBo.run
