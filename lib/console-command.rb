# frozen_string_literal: true

require_relative 'module.rb'
require_relative './bot.rb'
require 'json'
class CoDoBo
  class ConsoleCommand
    def initialize(module_manager)
      @module_manager = module_manager
    end

    def run
      @run = true
      while @run
        print "\u001b[37m$ \u001b[32mcpgui-#{CoDoBo.version}\u001b[33m: "
        consoleCommand = STDIN.gets.chomp
        consolecommand_list = consoleCommand.split(' ')
        next if consolecommand_list.empty?

        consoleCommandPrefix = consolecommand_list[0]
        consoleCommandArgs = consolecommand_list[1..-1]
        puts "\u001b[91mCommand not exist!" unless @module_manager.consoleCommand(consoleCommandPrefix, consoleCommandArgs)
      end
    end

    def stop
      @run = false
    end
  end
end
