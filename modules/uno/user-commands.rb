# frozen_string_literal: true

require_relative './uno-module.rb'
class UnoModule
  def userCommand(command, args, event)
    commandLanguage = @language.getJson(event.server.id)['commands']
    if commandLanguage['uno']['aliases'].include? command
      if !args.empty?
        if event.user.permission? :administrator
          case args[0]
          when *commandLanguage['help']['aliases']
            event.send_temporary_message format(commandLanguage['help']['output'], u: event.author.username), 10
          when *commandLanguage['category']['aliases']
            if args.length == 1
              @client.query("SELECT * FROM `uno` WHERE SERVERID=#{event.server.id}").each do |row|
                if row['CATEGORY'].nil?
                  event.send_temporary_message format(commandLanguage['category']['noget']), 10
                else
                  channel = event.bot.channel(row['CATEGORY'].to_i)
                  if channel.nil?
                    event.send_temporary_message format(commandLanguage['category']['noget']), 10
                  else
                    event.send_temporary_message format(commandLanguage['category']['get'], c: channel.name, i: channel.id), 10
                  end
                end
              end
            elsif args.length == 2
              if args[1].numeric?
                channel = event.bot.channel(args[1].to_i)
                if channel.nil?
                  event.send_temporary_message format(commandLanguage['category']['notexist'], c: channel.name, i: channel.id), 10
                else
                  if channel.category?
                    puts "UPDATE `uno` SET CATEGORY=#{channel.id} WHERE SERVERID=#{channel.server.id};"
                    @client.query("UPDATE `uno` SET CATEGORY=#{channel.id} WHERE SERVERID=#{channel.server.id};")
                    event.send_temporary_message format(commandLanguage['category']['set'], c: channel.name, i: channel.id), 10
                  else
                    event.send_temporary_message format(commandLanguage['category']['notexist'], c: args[1]), 10
                  end
                end
                @client.query("SELECT * FROM `uno` WHERE SERVERID=#{event.server.id}").each do |row|
                  if row['CATEGORY'].nil?
                    event.send_temporary_message format(commandLanguage['category']['noget']), 10
                  end
                end
              else
                event.send_temporary_message format(commandLanguage['category']['notexist'], c: args[1]), 10
              end
            else
              event.send_temporary_message format(commandLanguage['notexist'], u: event.author.username), 10
            end
          else
            event.send_temporary_message format(commandLanguage['notexist'], u: event.author.username), 10
          end
        else
          event.send_temporary_message format(commandLanguage['help']['nopermission'], u: event.author.username), 10
        end
      else
        event.send_temporary_message format(commandLanguage['uno']['output'], u: event.author.username), 10
    end
  end
  end

  def message(event); end
end
