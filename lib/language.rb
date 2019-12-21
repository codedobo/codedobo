# frozen_string_literal: true

require 'json'

class CoDoBo
  class Language
    #
    # Language system for individual servers
    #
    # @param [Mysql2::Client] client <description>
    # @param [String] folder Where all language files are (see MainModule)
    #
    def initialize(client, folder)
      @folder = folder
      @language = {}
      @client = client
      reload
    end

    # Returns a hash with the file name as key
    # @return [Hash<String,String>] Hash(ServerID, Language)
    attr_reader :language

    # The folder of the translations
    # @return [String]
    attr_reader :folder

    # Get a value in the language file
    # @return [Object, nil]
    def get(*keys)
      current_section = @languages[@language]
      return nil if current_section.nil?

      keys.each do |key|
        return nil unless current_section.key? key

        current_section = current_section[key]
      end
      current_section
    end

    def get(serverID)
      path = "#{@folder}/#{@language[serverID]}.json"
      file = File.open path
      file
    end

    def getJson(serverID)
      data = JSON.load get(serverID)
      return data
    end

    # Load all languages from the servers
    def reload
      @language.clear
      @client.query('SELECT * FROM `main`;').each do |row|
        @language[row['SERVERID']] = row['LANGUAGE']
      end
    end
  end
end
