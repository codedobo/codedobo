# frozen_string_literal: true

require_relative './console-command.rb'
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
    @server_prefix = {}
    setup
    @module_manager = CoDoBo::ModuleManager.new(self, client, modules)
    @console_command = CoDoBo::ConsoleCommand.new(@module_manager)
    @user_command = CoDoBo::UserCommand.new(self, @module_manager)
  end
  attr_reader :discord
  attr_reader :user_command
  attr_reader :database
  attr_reader :server_prefix
  attr_reader :console_command
  def run
    puts 'Starting discord bot...'
    discord.run(true)
    discord.game = 'github/CodeDoctorDE'
    puts 'Successfully started discord bot!'
    @module_manager.run
    @console_command.run
  end

  def exit
    puts 'Bye'
    discord.stop(false)
    @module_manager.stop
    @console_command.stop
  end

  def restart
    @module_manager.stop
    @console_command.stop
    @module_manager.run
    @console_command.run
  end

  def self.version
    @@version
  end
end
