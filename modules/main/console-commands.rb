# frozen_string_literal: true

require_relative './index.rb'
class MainModule
  include CoDoBo::BotModule
  def consoleCommand(command, _args)
    if command == 'main'
      puts "\u001b[96mRunning main@#{@@moduleVersion} module by #{@@moduleDeveloper}!"
      true
    elsif %w[re rl rel res rest restart reload].include? command
      puts "\u001b[36mReloading application..."
      @module_manager.bot.restart
      puts "\u001b[32mSuccessfully reloaded application!"
      true
    elsif %w[exit close quit stop].include? command
      puts "\u001b[96mExiting application..."
      @module_manager.bot.exit
      puts "\u001b[32mBye!"
      exit!
    end
  end
end
