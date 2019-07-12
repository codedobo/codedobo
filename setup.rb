# frozen_string_literal: true

require_relative './bot.rb'
class CoDoBo
  def setup
    puts 'Setup up core database...'
    @client.query("CREATE TABLE IF NOT EXISTS `main` (
      `SERVERID` bigint(255) NOT NULL,
      `LANGUAGE` varchar(255) NOT NULL,
      `PREFIX` varchar(255) NOT NULL,
      PRIMARY KEY  (`SERVERID`)
    );")
    puts 'Successfully set up core databasee!'
  end
end
