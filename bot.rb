# frozen_string_literal: true

require_relative './console-command.rb'
require_relative './user-command.rb'
require_relative './setup.rb'
class String
  def numeric?
    !Float(self).nil?
  rescue StandardError
    false
  end
end
class CoDoBo
  @@version = '0.5'
  def initialize(discord, client, modules)
    @discord = discord
    @client = client
    @serverPrefix = {}
    setup
    @module_manager = CoDoBo::ModuleManager.new(self, client, modules)
    @consoleCommand = CoDoBo::ConsoleCommand.new(@module_manager)
    @userCommand = CoDoBo::UserCommand.new(self, @module_manager)
  end
  attr_reader :discord
  attr_reader :userCommand
  attr_reader :database
  attr_reader :serverPrefix
  attr_reader :consoleCommand
  def run
    puts 'Starting discord bot...'
    discord.run(true)
    discord.game = 'github/CodeDoctorDE'
    puts 'Successfully started discord bot!'
    @module_manager.run
    @consoleCommand.run
  end

  def exit
    puts 'Bye'
    discord.stop(false)
    @module_manager.exit
    @consoleCommand.stop
  end

  def restart
    @module_manager.exit
    @consoleCommand.stop
    @module_manager.run
    @consoleCommand.run
  end

  def self.version
    @@version
  end
end
