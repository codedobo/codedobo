# frozen_string_literal: true

require_relative './main-module.rb'
class MainModule
  include BotModule
  def consoleCommand(command, _args)
    if command == 'main'
      puts "Running main@#{@@moduleVersion} module!"
      true
    elsif %w[exit close quit stop].include? command
      puts 'Exiting application...'
      exit
      true
    end
  end
end
