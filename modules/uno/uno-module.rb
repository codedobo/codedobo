# frozen_string_literal: true

require_relative '../module.rb'
class UnoModule
  include BotModule
  @@moduleVersion = '0.5'
  def start(client)
    puts 'Starting UNO module...'
    @client = client
    setup
    puts 'Successfully started UNO module!'
  end

  def consoleCommand(command, _args)
    puts "Running uno@#{@@moduleVersion} module!" if command == 'uno'
  end
  attr_reader :data
end
