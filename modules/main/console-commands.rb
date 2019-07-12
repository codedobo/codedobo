# frozen_string_literal: true

require_relative './main-module.rb'
class MainModule
  include BotModule
  def consoleCommand(command, _args)
    puts "Running main@#{@@moduleVersion} module!" if command == 'main'
    if %w[exit close quit stop].include? command
      puts 'Exiting application...'
      exit
    end
  end
end
