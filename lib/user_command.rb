# frozen_string_literal: true

require_relative './bot.rb'
class CoDoBo
  # This class handle the commands from the users in the discord server
  class UserCommand
    #
    # The command manager for all user commands in the guilds!
    #
    # @param [CoDoBo] bot
    # @param [CoDoBo::ModuleManager] module_manager
    #
    def initialize(bot, module_manager)
      @bot = bot
      @module_manager = module_manager

      @bot.discord.message do |event|
        run(event)
      end
    end
    attr_reader :bot

    #
    # Run an user command
    #
    # @param [Discordrb::Events::MessageEvent] event The send event
    #
    # @return [<Type>] <description>
    #
    def run(event)
      if bot.server_prefix
        if bot.server_prefix.include? event.server.id
          if event.content.start_with?(bot.server_prefix[event.server.id])
            command_string = event.content[bot.server_prefix[event.server.id].length..-1]
            command_list = command_string.split(' ')

            unless command_list.empty?
              command = command_list[0]
              command_args = command_list[1..-1]
              @module_manager.user_command(command, command_args, event)
            else
              @module_manager.user_command("", nil, event)
            end
          end
        end
      end
    end
  end
end
