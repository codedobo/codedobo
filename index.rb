# frozen_string_literal: true

require 'discordrb'

require_relative 'modules/module.rb'
require_relative 'setup.rb'
require_relative 'console-command.rb'

# Dir['modules/*.rb'].each do |file|
#   require file
# end
version = '0.0.1'

puts 'Starting bot...'
raise 'Please enter a token!' if ARGV.length != 1

if ARGV.length != 1
  print 'Please enter a token!'
  botToken = gets.chomp
else
  botToken = ARGV[0]
end

bot = Discordrb::Bot.new token: botToken

bot.message(with_text: 'Ping!') do |event|
  event.respond 'Pong!'
end

# Commands
# commandBotEN = Discordrb::Commands::CommandBot.new token: botToken, prefix: '.', help_command: false, no_permission_message: 'You do not have permission to execute command!', command_doesnt_exist_message: 'This command does not exist!'
# commandBotEN.command :hello, aliases: %w[welcome me] do |event|
#   event << event.user.mention
#   event << "Hi! I'm CoDoBo, the bot by CodeDoctor! I would like to help you! If you are interested in me, use .info! If you want to get all commands, use .help"
# end
# commandBotEN.command :help, usage: 'Usage: .help!', max_args: 0 do |event|
#   event << event.user.mention
#   event << "**The commands:** (#{commandBotEN.commands.length})"
#   commands = ''
#   commandBotEN.commands.each do |key, value|
#     next if value.is_a?(Discordrb::Commands::CommandAlias)

#     commands += "`.#{key}`(#{value.attributes[:aliases].map { |i| %('`#{i}`') }.join(', ')})\n#{value.attributes[:description]}\n\n"
#   end
#   event << commands
# end
# commandBotEN.command :info, usage: 'Usage: .info' do |event|
# end

# commandBotDE = Discordrb::Commands::CommandBot.new token: botToken, prefix: '?', help_command: false, no_permission_message: 'Du hast keine Rechte, diesen Befehl auszuführen!', command_doesnt_exist_message: 'Dieser Befehl existiert nicht'
# commandBotDE.command :hallo, aliases: %w[willkommen ich] do |event|
#   event << event.user.mention
#   event << 'Hallo! Ich bin CoDoBo, der Bot von CodeDoctor! Ich möchte dir helfen! Wenn du interessiert an mir bist, benutze #info!'
# end
# commandBotDE.command :info, usage: 'Benutzung: ?info', max_args: 0 do |event|
#   event << 'Hallo :D'
# end
# commandBotDE.command :hilfe, usage: 'Benutzung: ?hilfe', max_args: 0 do |event|
#   event << event.user.mention
#   event << "**The commands:** (#{commandBotEN.commands.length})"
#   commands = ''
#   commandBotEN.commands.each do |key, value|
#     next if value.is_a?(Discordrb::Commands::CommandAlias)

#     commands += "`.#{key}`\n#{value.attributes[:description]}\n#{value.attributes[:aliases]}\n\n"
#   end
#   event << commands
# end
puts 'Starting command bot...'
Thread.new do
  commandBotDE.run
end
Thread.new do
  commandBotEN.run
end
moduleManager = ModuleManager.new([UnoModule.new])

consoleCommand
puts 'Successfully started command bot!'
puts 'Starting bot...'
bot.run
puts 'Successfully started bot!'
