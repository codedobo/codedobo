require "discordrb"
class Application
    def initialize(user,description,message)
        @user = user
        @description = description
        @message = message
    end
    def message
        @message
    end
    def description
        @description
    end
end
class ApplicationListener
    def initialize()
        
    end
end