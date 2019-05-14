require 'discordrb'
:botToken = ENV["token"]
bot = Discordrb::Bot.new token: :botToken

bot.message(with_text: 'Ping!') do |event|
  event.respond 'Pong!'
end

require_relative("commands.ruby")

bot.run