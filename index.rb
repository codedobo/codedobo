# frozen_string_literal: true
# @return [void]
def send_message(message)
  puts "\e[35m[Loader] " + message + "\e[0m"
end

send_message "\e[33mWelcome to the CoDoBo! Starting bot..."

require 'discordrb'
require 'json'
require 'mysql2'
send_message "\e[33mReading lib folder..."
Dir[File.join('./lib', '**/*.rb')].each do |file|
  send_message "\e[33mIncluding #{file}..."
  require_relative file
  send_message "\e[32mSuccessfully included #{file}!"
end
send_message "\e[32mSuccessfully read lib folder!"

if ARGV.length != 1
  print 'Please enter a token: '
  botToken = STDIN..chomp
else
  botToken = ARGV[0]
end

bot = Discordrb::Bot.new token: botToken
puts "\u001b[36mConnecting to mysql..."
file = File.open 'database.json'
databaseData = JSON.load file
file.close
client = Mysql2::Client.new(host: databaseData['host'], username: databaseData['username'], password: databaseData['password'], database: databaseData['database'])
send_message "\u001b[32mSuccessfully connected to mysql!"
coDoBo = CoDoBo.new(bot, client)
send_message "\u001b[32mSuccessfully started CoDoBo!"
coDoBo.run
