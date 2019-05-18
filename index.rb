require 'discordrb'
puts "Starting bot..."
botToken = ARGV[0]
bot = Discordrb::Bot.new token: botToken

bot.message(with_text: 'Ping!') do |event|
  event.respond 'Pong!'
end


# Commands
commandBot = Discordrb::Commands::CommandBot.new token: botToken, prefix: '.',help_command: false
commandBot.command :user do |event|
  event.user.name
end
commandBot.command :help do |event|
  event << "Hi! I'm CoDoBo, the bot by CodeDoctor!"
end
commandBot.run



puts "Successfully started the bot!"
bot.run
loop do
end