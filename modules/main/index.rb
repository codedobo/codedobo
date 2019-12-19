# frozen_string_literal: true

require_relative './user-commands.rb'
require_relative './console-commands.rb'
require_relative './setup.rb'
class MainModule
  include BotModule
  @@moduleVersion = '0.5'
  @@moduleDeveloper = 'CodeDoctorDE'
  def start(client, module_manager)
    puts "\u001b[96mStarting main module..."
    @client = client
    @module_manager = module_manager
    @language = BotModule::Language.new __dir__ + '/language', @client
    setup
    @module_manager.bot.discord.message do |event|
      message(event)
    end
    puts "\u001b[32mSuccessfully started main module!"
  end

  def join(server, _already)
    puts "\u001b[96mSet up main module for #{server.id}..."
    id = server.id
    language = 'en'
    prefix = '+cdb'
    @client.query("INSERT INTO `main` VALUES (#{id},'#{language}','#{prefix}') ON DUPLICATE KEY UPDATE LANGUAGE='#{language}', PREFIX='#{prefix}';")
    updatePrefix
    puts "\u001b[32mSuccessfully set up main module for #{server.id}!"
  end

  def updatePrefix
    @client.query('SELECT * FROM `main`').each do |row|
      serverID = row['SERVERID']
      @module_manager.bot.server_prefix[serverID] = row['PREFIX']
    end
  end
end
