# frozen_string_literal: true

require_relative './console_cmd_manager.rb'
require_relative './setup.rb'
class String
  def numeric?
    !Float(self).nil?
  rescue StandardError
    false
  end
end
class CoDoBo
  def initialize(discord, client)
    @discord = discord
    @client = client
    @server_prefix = {}
    setup
    @module_manager = CoDoBo::ModuleManager.new(self, client)
    @user_cmd_manager = CoDoBo::UserCommandManager.new(self, @module_manager)
    @console_cmd_manager = CoDoBo::ConsoleCommandManager.new(self, @module_manager)
    @module_manager.detect
  end
  # @return [Discordrb::Bot]
  attr_reader :discord
  attr_reader :user_command
  attr_reader :database
  attr_reader :server_prefix
  attr_reader :console_command
  def run
    puts "\u001b[36mStarting discord bot..."
    discord.run(true)
    discord.game = 'github/CodeDoctorDE/codobo'
    @module_manager.start
    @console_cmd_manager.run
    @user_cmd_manager.run
    puts "\u001b[32mSuccessfully started discord bot!"
  end

  def stop
    puts 'Bye'
    discord.stop(false)
    @module_manager.stop
    @console_cmd_manager.stop
  end

  def restart
    @user_cmd_manager.stop
    @console_cmd_manager.stop
    @module_manager.restart
    @console_cmd_manager.run
    @user_cmd_manager.run
  end

  def self.version
    'Alpha 1.0.0'
  end

  def self.developer
    'CodeDoctorDE'
  end
end
