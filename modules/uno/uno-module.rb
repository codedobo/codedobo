# frozen_string_literal: true

require_relative '../module.rb'
class UnoModule
  include BotModule
  @@moduleVersion = '0.5'
  def start(client, _moduleManager)
    puts 'Starting uno module...'
    @client = client
    setup
    puts 'Successfully started uno module!'
  end

  def consoleCommand(command, _args)
    if command == 'uno'
      puts "Running uno@#{@@moduleVersion} module!"
      true
    end
  end
  attr_reader :data
end
