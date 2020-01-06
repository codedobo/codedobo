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
    # @return [Hash{String=>String}] Hash{ServerID=> Language}
    attr_reader :language

    # The folder of the translations
    # @return [String]
    attr_reader :folder

    def get(serverID)
      path = "#{@folder}/#{@language[serverID]}.json"
      file = File.open path
      file
    end

    #
    # Get the json file from the server id
    #
    # @param [String] serverID
    #
    # @return [Hash]
    #
    def get_json(serverID)
      data = JSON.load get(serverID)
      return data
    end

    #
    # Get all values of this key from all language files
    #
    # @param [Array(String)] *keys
    #
    # @return [Hash{String => Object}]
    #
    def get_language_hash(*keys)
      hash = {}
      languages.each{ |language|
        path = "#{@folder}/#{language}.json"
        data = JSON.load File.open path
        value = data
        keys.each {|key|
          value = value[key]
        }
        hash[language] = value
      }
      hash
    end

    def languages
      languages = []
      Dir.foreach(@folder) do |file|
        languages.push File.basename(file,File.extname(file))  if file.end_with?(".json")
      end
      languages
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
