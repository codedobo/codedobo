# frozen_string_literal: true

require_relative './index.rb'
class UnoModule
  def setup
    puts "\u001b[96mSet up up uno module..."
    @client.query("CREATE TABLE IF NOT EXISTS `uno` (
      `SERVERID` bigint(255) NOT NULL,
      `THEME` varchar(255) NOT NULL,
      `CATEGORY` bigint(255),
      PRIMARY KEY  (`SERVERID`)
    );")
    puts "\u001b[32mSuccessfully set up uno module!"
  end

  def join(server, _already)
    puts "\u001b[96mSet up uno module for #{server.id}..."
    id = server.id
    theme = 'default'
    @client.query("INSERT INTO `uno` VALUES (#{id},'#{theme}',NULL) ON DUPLICATE KEY UPDATE THEME='#{theme}';")
    match_making
    puts "\u001b[32mSuccessfully set up uno module for #{server.id}!"
  end

  def reload(server)
    puts "\u001b[96mReloading uno module for server #{server.name}(#{server.id})..."
    match_making
    puts "\u001b[32mSuccefully reloaded the uno module for the server!"
  end
end
