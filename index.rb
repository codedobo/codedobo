# frozen_string_literal: true

require 'discordrb'
require 'json'
require 'mysql2'
require_relative './module.rb'
require_relative './setup.rb'
require_relative './bot.rb'
puts 'Reading modules.json...'
file = File.open 'modules.json'
moduleData = JSON.load file
file.close
botModules = []
moduleData.each do |botModule|
  puts "Including #{botModule['class']}(#{botModule['file']})..."
  require_relative "./modules/#{botModule['file']}"
  botModuleClass = Object.const_get(botModule['class'])
  botModuleInstance = botModuleClass.new
  botModules.push(botModuleInstance)
  puts "Successfully included #{botModule['class']}(#{botModule['file']})..."
end
puts 'Successfully read modules.json!'

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
