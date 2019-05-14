require 'discordrb'
botToken = "NTU0MzY2ODQ0NDE3NjA1NjQy.XNrz-Q.Hz17rXMWT8Kg2xpBi28Lr4ppTcs"
bot = Discordrb::Bot.new token: botToken

bot.message(with_text: 'Ping!') do |event|
  event.respond 'Pong!'
end

require_relative 'commands'

bot.run
loop do
end