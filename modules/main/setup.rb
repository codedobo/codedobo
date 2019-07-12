# frozen_string_literal: true

require_relative './main-module.rb'
class MainModule
  def setup
    puts 'Setup up main module...'
    @client.query("CREATE TABLE IF NOT EXISTS `main` (
      `SERVERID` int(50) unsigned NOT NULL,
      `LANGUAGE` varchar(255) NOT NULL,
      PRIMARY KEY  (`SERVERID`)
    );")
    puts 'Successfully set up main module ...'
  end
end
