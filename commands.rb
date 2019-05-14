require 'discordrb'
botToken = "NTU0MzY2ODQ0NDE3NjA1NjQy.XNrz-Q.Hz17rXMWT8Kg2xpBi28Lr4ppTcs"
commandBot = Discordrb::Commands::CommandBot.new token: botToken, prefix: 'codobo'

commandBot.command :hello :welcome :user do |event|
    # Commands send whatever is returned from the block to the channel. This allows for compact commands like this,
    # but you have to be aware of this so you don't accidentally return something you didn't intend to.
    # To prevent the return value to be sent to the channel, you can just return `nil`.
    event << "Hello "+event.user.name + "! I'm CoDoBo! The Bot by CodeDoctor (<@336889257488547841>)! I would like to help you!"
    event << "Hallo "+event.user.name + "! Ich bin CoDoBo! Der Bot von CodeDoctor (<@336889257488547841>)! Ich möchte dir helfen!"
  end
  
  commandBot.run