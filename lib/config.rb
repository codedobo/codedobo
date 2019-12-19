# frozen_string_literal: true

require 'discordrb'
require 'json'
class Configuration
  def initialize(server, channelTopic, _prefix)
    hasChannel = false
    server.channels.each do |channel|
      channel.delete 'There is already a config channel!' if hasChannel
      topic = channel.topic
      next unless topic == channelTopic

      hasChannel = true
      hasMessage = false
      channel.history(1).each do |message|
        hasMessage = true
        @configurationMessage = ConfigurationMessage.new(channel, message)
        @config = JSON.parse(message.content)
      end
    end
  end
  attr_reader :configurationMessage
  attr_reader :config
  attr_accessor :config
  def save
    @configurationMessage.edit(@config.to_json)
  end

  def load
    @config = JSON.parse(@configurationMessage.message.content)
  end
end
class ConfigurationMessage
  def initialize(channel, message)
    @channel = channel
    @message = message
  end

  attr_reader :channel

  attr_reader :message
end
