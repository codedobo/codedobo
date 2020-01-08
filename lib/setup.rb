# frozen_string_literal: true

require_relative './bot.rb'
class CodeDoBo
  def setup
    puts "\u001b[36mSet up up core database..."
    @client.query("CREATE TABLE IF NOT EXISTS `main` (
      `SERVERID` bigint(255) NOT NULL,
      `LANGUAGE` varchar(255) NOT NULL,
      `PREFIX` varchar(255) NOT NULL,
      PRIMARY KEY  (`SERVERID`)
    );")
    puts "\u001b[32mSuccessfully set up core database!"
  end
end
