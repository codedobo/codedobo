# frozen_string_literal: true

require_relative 'modules/module.rb'
require 'json'
class CoDoBo
  class ConsoleCommand
    def initialize(botData, moduleManager)
      @botData = botData
      @moduleManager = moduleManager
    end

    def run
      @run = true
      while @run
        version = @botData['version']
        print "codobo-#{version}: "
        consoleCommand = STDIN.gets.chomp
        consoleCommandList = consoleCommand.split(' ')
        next if consoleCommandList.empty?

        consoleCommandPrefix = consoleCommandList[0]
        consoleCommandArgs = consoleCommandList[1..-1]
        @moduleManager.consoleCommand(consoleCommandPrefix, consoleCommandArgs)
      end
    end

    def stop
      @run = false
    end
  end
end
