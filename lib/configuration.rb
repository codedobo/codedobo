# frozen_string_literal: true

class CoDoBo
    # Control the json file
    class Configuration
      # @param file
      def initialize(file)
        @file = file
        reload
      end
  
      # @return [Object, nil]
      def get(*keys)
        current_section = @data
        keys.each do |key|
          return nil unless current_section.key? key
  
          current_section = current_section[key]
        end
        current_section
      end
  
      # Save the configuration
      # @return [void]
      def save
        File.open(@file) do |f|
          f.write(@data.to_json)
        end
      end
  
      # Reload current configuration
      # @return [void]
      def reload
        File.open(@file) do |file|
          @data = JSON.parse file.read
        end
      end
      attr_reader :file
    end
  end
  