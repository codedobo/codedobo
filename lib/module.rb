# frozen_string_literal: true

module BotModule
  @name = 'Name'
  def start(language, client, module_manager); end

  def consoleCommand(_command, _args)
    false
  end

  def user_command(_command, _args, _event)
    false
  end

  def join(server, already); end

  def help(user, channel); end

  def reload(server); end

  def stop; end
  class Language
    def initialize(path, client)
      @language = {}
      @path = path
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
      path = "#{@path}/#{@language[serverID]}.json"
      file = File.open path
      file
    end

    def getJson(serverID)
      data = JSON.load get(serverID)
      return data
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
        puts "Creating server #{event.server.name}(#{event.server.id})..."
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

    def user_command(command, args, event)
      @modules.each { |botModule| botModule.user_command(command, args, event) }
    end

    def join(server, already)
      @modules.each { |botModule| botModule.join(server, already) }
    end

    def help(_user, _channel)
      ''
    end

    def stop
      puts 'Exiting all modules...'
      @modules.each(&:stop)
      puts 'Successfully exited all modules!'
    end
    attr_reader :modules
    attr_reader :bot
  end
end
