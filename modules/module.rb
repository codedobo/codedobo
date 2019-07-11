# frozen_string_literal: true

module BotModule
  def start; end

  def consoleCommand(_command, _args)
    false
  end

  def stop; end
end
class ModuleManager
  def initialize(modules)
    @modules = modules
  end

  def start
    @modules.each(&:start)
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
