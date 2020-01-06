# frozen_string_literal: true

require_relative './user-commands.rb'
require_relative './console-commands.rb'
require_relative './setup.rb'
class MainModule include CoDoBo::BotModule
  def initialize(app_class, module_manager)
    send_message "\u001b[96mStarting main module..."
    @module_manager = module_manager
    @app_class = app_class
    @language = CoDoBo::Language.new module_manager.client, __dir__ + '/language'
    setup
    send_message "\u001b[32mSuccessfully started main module!"
  end
  def on_enable
    register_console_commands
    register_user_commands
  end

  def join(server, _already)
    send_message "\u001b[96mSet up main module for #{server.id}..."
    id = server.id
    language = 'en'
    prefix = '+cdb'
    @module_manager.client.query("INSERT INTO `main` VALUES (#{id},'#{language}','#{prefix}') ON DUPLICATE KEY UPDATE LANGUAGE='#{language}', PREFIX='#{prefix}';")
    update_prefix
    send_message "\u001b[32mSuccessfully set up main module for #{server.id}!"
  end

  def update_prefix
    @module_manager.client.query('SELECT * FROM `main`').each do |row|
      serverID = row['SERVERID']
      @module_manager.bot.server_prefix[serverID] = row['PREFIX']
    end
  end
end
