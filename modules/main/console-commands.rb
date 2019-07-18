# frozen_string_literal: true

require_relative './index.rb'
class MainModule
  include BotModule
  def consoleCommand(command, _args)
    if command == 'main'
      puts "Running main@#{@@moduleVersion} module by #{@@moduleDeveloper}!"
      true
    elsif %w[re rl rel res rest restart reload].include? command
      puts 'Reloading application...'
      @module_manager.bot.restart
      true
    elsif %w[exit close quit stop].include? command
      puts 'Exiting application...'
      @module_manager.bot.exit
      puts 'Bye!'
      exit!
    end
  end
end
