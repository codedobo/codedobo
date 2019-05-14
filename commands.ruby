require_relative("index.ruby")
commandBot = Discordrb::Commands::CommandBot.new token: :botToken, prefix: '!'

commandBot.command :user do |event|
    # Commands send whatever is returned from the block to the channel. This allows for compact commands like this,
    # but you have to be aware of this so you don't accidentally return something you didn't intend to.
    # To prevent the return value to be sent to the channel, you can just return `nil`.
    event.user.name
  end
  
  commandBot.command :bold do |_event, *args|
    # Again, the return value of the block is sent to the channel
    "**#{args.join(' ')}**"
  end
  
  commandBot.command :italic do |_event, *args|
    "*#{args.join(' ')}*"
  end
  
  commandBot.command(:invite, chain_usable: false) do |event|
    # This simply sends the bot's invite URL, without any specific permissions,
    # to the channel.
    event.bot.invite_url
  end
  
  commandBot.command(:random, min_args: 0, max_args: 2, description: 'Generates a random number between 0 and 1, 0 and max or min and max.', usage: 'random [min/max] [max]') do |_event, min, max|
    # The `if` statement returns one of multiple different things based on the condition. Its return value
    # is then returned from the block and sent to the channel
    if max
      rand(min.to_i..max.to_i)
    elsif min
      rand(0..min.to_i)
    else
      rand
    end
  end
  
  commandBot.command :long do |event|
    event << 'This is a long message.'
    event << 'It has multiple lines that are each sent by doing `event << line`.'
    event << 'This is an easy way to do such long messages, or to create lines that should only be sent conditionally.'
    event << 'Anyway, have a nice day.'
  
    # Here we don't have to worry about the return value because the `event << line` statement automatically returns nil.
  end
  
  bot.run