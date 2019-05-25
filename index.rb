require 'discordrb'
require "./application.rb"
puts "Starting bot..."
botToken = ARGV[0]
bot = Discordrb::Bot.new token: botToken

bot.message(with_text: 'Ping!') do |event|
  event.respond 'Pong!'
end


# Commands
commandBotEN = Discordrb::Commands::CommandBot.new token: botToken, prefix: '.',help_command: false,no_permission_message: "You do not have permission to execute command!",command_doesnt_exist_message: "This command does not exist!"
commandBotEN.command :user do |event|
  event.user.name
end
commandBotEN.command :hello,aliases:["welcome","me"] do |event|
  event << "Hi! I'm CoDoBo, the bot by CodeDoctor! I would like to help you! If you are interested in me, use .info! If you want to get all commands, use .help"
end
commandBotEN.command :help,usage:"Usage: .help!",max_args:0 do |event|
  event << event.user.mention
  event << "**The commands:** #{commandBotEN.commands.length}"
  commandBotEN.commands.each do |key,value|
    next if value.is_a?(Discordrb::Commands::CommandAlias)
    event << "`.#{key}`"
  end
end
commandBotEN.command :info,usage: "Usage: .info" do |event|

end
commandBotEN.run

commandBotDE = Discordrb::Commands::CommandBot.new token: botToken, prefix: '?',help_command: false,no_permission_message: "Du hast keine Rechte, diesen Befehl auszuführen!";command_doesnt_exist_message:"Dieser Befehl existiert nicht"

commandBotDE.command :info,usage: "Benutzung: ?info",max_args:0 do |event|
  event << "Hallo :D"
end
commandBotDE.command :hilfe,usage: "Benutzung: ?hilfe",max_args:0 do |event|
  event << "Hallo! Ich bin CoDoBo, der Bot von CodeDoctor! Ich möchte dir helfen! Wenn du interessiert an mir bist, benutze #info!"
end
commandBotDE.run

puts "Successfully started the bot!"
bot.run
loop do
end