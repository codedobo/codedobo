# frozen_string_literal: true

require_relative './console-command.rb'
require_relative './user-command.rb'
require_relative './setup.rb'
class String
  def numeric?
    Float(self) != nil rescue false
  end
end
class CoDoBo
  @@version = '0.5'
  def initialize(discord, client, modules)
    @discord = discord
    @client = client
    @serverPrefix = {}
    setup
    @moduleManager = CoDoBo::ModuleManager.new(self, client, modules)
    @consoleCommand = CoDoBo::ConsoleCommand.new(@moduleManager)
    @userCommand = CoDoBo::UserCommand.new(self, @moduleManager)
  end
  attr_reader :discord
  attr_reader :userCommand
  attr_reader :database
  attr_reader :serverPrefix
  def run
    puts 'Starting discord bot...'
    discord.run(true)
    puts 'Successfully started discord bot!'
    @discord.game = 'github/CodeDoctorDE'
    @moduleManager.run
    @consoleCommand.run
  end

  def self.version
    @@version
  end
end
