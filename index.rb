# frozen_string_literal: true
# @return [void]
def send_message(message)
  puts "\e[35m[Loader] " + message + "\e[0m"
end

send_message "\e[33mWelcome to the CodeDoBo! Starting bot..."

require 'discordrb'
require 'json'
require 'sequel'
send_message "\e[33mReading lib folder..."
Dir[File.join('./lib', '**/*.rb')].each do |file|
  send_message "\e[33mIncluding #{file}..."
  require_relative file
  send_message "\e[32mSuccessfully included #{file}!"
end
send_message "\e[32mSuccessfully read lib folder!"

config_data = JSON.parse File.read('config.json')
bot = Discordrb::Bot.new token: config_data['token']
puts "\u001b[36mConnecting to mysql..."
client = Sequel.connect(host: config_data['host'], user: config_data['username'], password: config_data['password'], database: config_data['database'], adapter: config_data['adapter'])
send_message "\u001b[32mSuccessfully connected to mysql!"
codobo = CodeDoBo.new(bot, client)
send_message "\u001b[32mSuccessfully started CodeDoBo!"
codobo.run
