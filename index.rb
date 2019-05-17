require 'discordrb'
puts "Starting bot..."
botToken = ARGV[0]
bot = Discordrb::Bot.new token: botToken

bot.message(with_text: 'Ping!') do |event|
  event.respond 'Pong!'
end


//Commands
commandBot = Discordrb::Commands::CommandBot.new token: botToken, prefix: '!'
commandBot.help_command = false
commandBot.command :user do |event|
  event.user.name
end





bot.run
puts "Successfully started the bot!"
loop do
end