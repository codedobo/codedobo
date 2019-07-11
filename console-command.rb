# frozen_string_literal: true

require_relative 'modules/module.rb'
def consoleCommand(moduleManager)
  Thread.new do
    loop do
      print "codobo-#{version}: "
      consoleCommand = STDIN.gets.chomp
      consoleCommandList = consoleCommand.split(' ')
      unless consoleCommandList.empty?
        consoleCommandPrefix = consoleCommandList[0]
        consoleCommandArgs = consoleCommandList[1..]
        moduleManager.consoleCommand(consoleCommandPrefix,consoleCommandArgs)
      end
    end
  end
end
