# frozen_string_literal: true

module BotModule
  def start(serverConfig); end

  def setup(client, database); end

  def consoleCommand(_command, _args)
    false
  end

  def stop; end
end
class CoDoBo
  class ModuleManager
    def initialize(_client, database, modules)
      @modules = modules
      @database = database
      @modules.each { |botModule| botModule.setup(@client, @database) }
    end

    def start(serverConfig)
      @modules.each { |botModule| botModule.start(serverConfig) }
    end

    def consoleCommand(command, args)
      @modules.each { |botModule| botModule.consoleCommand(command, args) }
    end

    def userCommand; end

    def stop
      @modules.each(&:stop)
    end
    attr_reader :modules
  end
end
