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
    @moduleManager = CoDoBo::ModuleManager.new(self, client, modules)
    @consoleCommand = CoDoBo::ConsoleCommand.new(@moduleManager)
    @userCommand = CoDoBo::UserCommand.new(self, @moduleManager)
  end
  attr_reader :discord
  attr_reader :userCommand
  attr_reader :database
  attr_reader :serverPrefix
  attr_reader :consoleCommand
  def run
    puts 'Starting discord bot...'
    discord.run(true)
    discord.game = 'github/CodeDoctorDE'c!uno setcategory 599223484643803136

    puts 'Successfully started discord bot!'
    @moduleManager.run
    @consoleCommand.run
  end

  def exit
    puts 'Bye'
    discord.stop(false)
    @moduleManager.exit
    @consoleCommand.stop
  end

  def restart
    @moduleManager.exit
    @consoleCommand.stop
    @moduleManager.run
    @consoleCommand.run
  end

  def self.version
    @@version
  end
end
