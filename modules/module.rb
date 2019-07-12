# frozen_string_literal: true

module BotModule
  def start(client, moduleManager); end

  def consoleCommand(_command, _args)
    false
  end

  def userCommand(_event)
    false
  end

  def join(server, already); end

  def stop; end
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
        join(server, true)
      end
      @bot.discord.server_create do |event|
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

    def userCommand(event)
      @modules.each { |botModule| botModule.userCommand(event) }
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
