# frozen_string_literal: true

require_relative '../module.rb'
class MainModule
  include BotModule
  def initialize; end

  def consoleCommand(command, _args)
    if command == 'stop'
      puts 'Exiting application...'
      exit
    end
  end
end
