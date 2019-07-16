# frozen_string_literal: true

require 'discordrb'
require 'json'
require 'mysql2'
require_relative './module.rb'
require_relative './setup.rb'
require_relative './bot.rb'
Dir[File.join('.', '**/*.rb')].each do |file|
  puts "Including #{file}..."
  require_relative file
end

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
coDoBo = CoDoBo.new(bot, client, [UnoModule.new, MainModule.new])
puts 'Successfully started CoDoBo!'
coDoBo.run
