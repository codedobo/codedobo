require 'discordrb'
require 'json'
class Configuration
    @configMessage = {}
    def initialize(bot,channelTopic,prefix)
        bot.servers.each {|serverID,server|
            hasChannel = false
            server.channels.each {|channel|
                if(hasChannel)
                    channel.delete "There is already a config channel!"
                end
                topic = channel.topic
                if(topic == channelTopic)
                    hasChannel = true
                    hasMessage = false
                    channel.history(1).each {|message| 
                        hasMessage = true
                        configMessage.push({server,{channel}})
                    }
                end
            }
        }  
    end
end
class ConfigurationMessage
    def initialize(channel,message)
        @channel = channel
        @message = message
    end
    def channel
        @channel
    end
    def message
        @message
    end
end