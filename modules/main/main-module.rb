# frozen_string_literal: true

require_relative '../module.rb'
require_relative './user-commands.rb'
require_relative './setup.rb'
class MainModule
  include BotModule
  @@moduleVersion = '0.5'
  def start(client)
    puts 'Starting main module...'
    @client = client
    setup
    puts 'Successfully started main module!'
  end
end
