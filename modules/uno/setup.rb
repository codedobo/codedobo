# frozen_string_literal: true

require_relative './uno-module.rb'
class UnoModule
  def setup
    puts 'Set up up uno module...'
    @client.query("CREATE TABLE IF NOT EXISTS `uno` (
      `SERVERID` bigint(255) NOT NULL,
      `THEME` varchar(255) NOT NULL,
      `CATEGORY` bigint(255),
      PRIMARY KEY  (`SERVERID`)
    );")
    puts 'Successfully set up uno module!'
  end

  def join(server, _already)
    puts "Set up uno module for #{server.id}..."
    id = server.id
    theme = 'default'
    @client.query("INSERT INTO `uno` VALUES (#{id},'#{theme}',NULL) ON DUPLICATE KEY UPDATE THEME='#{theme}';")
    puts "Successfully set up uno module for #{server.id}!"
  end
end
