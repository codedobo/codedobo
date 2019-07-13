# frozen_string_literal: true

require_relative '../module.rb'
require_relative './user-commands.rb'
require_relative './setup.rb'
class MainModule
  include BotModule
  @@moduleVersion = '0.5'
  @@moduleDeveloper = 'CodeDoctorDE'
  def start(client, moduleManager)
    puts 'Starting main module...'
    @client = client
    @moduleManager = moduleManager
    @language = BotModule::Language.new 'main', @client
    setup
    @moduleManager.bot.discord.message do |event|
      message(event)
    end
    puts 'Successfully started main module!'
  end

  def join(server, _already)
    id = server.id
    language = 'en'
    prefix = 'c!'
    puts "Joining server #{server.name}(#{id})..."
    @client.query("INSERT INTO `main` VALUES (#{id},'#{language}','#{prefix}') ON DUPLICATE KEY UPDATE LANGUAGE='#{language}', PREFIX='#{prefix}';")
    updatePrefix
  end

  def updatePrefix
    @client.query('SELECT * FROM `main`').each do |row|
      serverID = row['SERVERID']
      @moduleManager.bot.serverPrefix[serverID] = row['PREFIX']
    end
  end
end
