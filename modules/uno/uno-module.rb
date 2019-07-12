# frozen_string_literal: true

require_relative '../module.rb'
class UnoModule
  include BotModule
  @@moduleVersion = '0.5'
  def start
    setup(client)
  end

  def consoleCommand(command, _args)
    puts "Running uno@#{@@moduleVersion} module!" if command == 'uno'
  end
  attr_reader :data
end
