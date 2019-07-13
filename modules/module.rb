# frozen_string_literal: true

module BotModule
  @name = 'Name'
  def start(language, client, moduleManager); end

  def consoleCommand(_command, _args)
    false
  end

  def userCommand(_command, _args, _event)
    false
  end

  def join(server, already); end

  def stop; end
  class Language
    def initialize(name, client)
      @language = {}
      @name = name
      @client = client
      load
    end

    def load
      @language.clear
      @client.query('SELECT * FROM `main`;').each do |row|
        @language[row['SERVERID']] = row['LANGUAGE']
      end
    end

    def get(serverID)
      path = "language/#{@language[serverID]}/#{@name}.json"
      file = File.open path
      file
    end

    def getJson(serverID)
      data = JSON.load get(serverID)
      data
    end
    attr_reader :name
    attr_reader :language
  end
end
class CoDoBo
  class ModuleManager
    def initialize(bot, client, modules)
      @bot = bot
      @modules = modules
      @client = client
      start
    end

    def run
      @bot.discord.servers.each do |_id, server|
        puts "Joining server #{server.name}(#{server.id})..."
        join(server, true)
      end
      @bot.discord.server_create do |event|
        puts "Creating server #{server.name}(#{server.id})..."
        join(event.server, false)
      end
    end

    def start
      @modules.each { |botModule| botModule.start(@client, self) }
    end

    def consoleCommand(command, args)
      exist = false
      @modules.each do |botModule|
        exist = true if botModule.consoleCommand(command, args)
      end
      exist
    end

    def userCommand(command, args, event)
      @modules.each { |botModule| botModule.userCommand(command, args, event) }
    end

    def join(server, already)
      @modules.each { |botModule| botModule.join(server, already) }
    end

    def stop
      @modules.each(&:stop)
    end
    attr_reader :modules
    attr_reader :bot
  end
end
