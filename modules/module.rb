# frozen_string_literal: true

module BotModule
  def start(client, database); end

  def consoleCommand(_command, _args)
    false
  end

  def stop; end
end
class CoDoBo
  class ModuleManager
    def initialize(client, modules)
      @modules = modules
      @client = client
    end

    def start
      @modules.each { |botModule| botModule.start(client) }
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
