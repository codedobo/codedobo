# frozen_string_literal: true

require_relative './uno-module.rb'
class UnoModule
  def message(event); end

  def userCommand(command, args, event)
    commandLanguage = @language.getJson(event.server.id)['commands']
    if commandLanguage['uno']['aliases'].include? command
      if args.empty?
        output = commandLanguage['uno']['output']
        event.send_temporary_message format(output, v: @@moduleVersion), 10
      else
        if event.user.permission? :administrator
          case args[0]
          when *commandLanguage['help']['aliases']
            event.send_temporary_message format(commandLanguage['help']['output'], u: event.author.username), 10
          when *commandLanguage['category']['get']['aliases']
            if args.length == 1
              @client.query("SELECT * FROM `uno` WHERE SERVERID=#{event.server.id}").each do |row|
                if row['CATEGORY'].nil?
                  event.send_temporary_message format(commandLanguage['category']['get']['no']), 10
                else
                  channel = event.bot.channel(row['CATEGORY'].to_i)
                  if channel.nil?
                    event.send_temporary_message format(commandLanguage['category']['get']['no']), 10
                  else
                    event.send_temporary_message format(commandLanguage['category']['get']['output'], c: channel.name, i: channel.id), 10
                  end
                end
              end
            else
              event.send_temporary_message format(commandLanguage['category']['get']['usage']), 10
            end
          when *commandLanguage['category']['set']['aliases']
            if args.length == 2
              if args[1].numeric?
                channel = event.bot.channel(args[1].to_i, event.server)
                if channel.server.id == event.server.id
                  if channel.nil?
                    event.send_temporary_message format(commandLanguage['category']['set']['notexist'], c: channel.name, i: channel.id), 10
                  else
                    if channel.category?
                      @client.query("UPDATE `uno` SET CATEGORY=#{channel.id} WHERE SERVERID=#{channel.server.id};")
                      event.send_message format(commandLanguage['category']['set']['output'], c: channel.name, i: channel.id)
                      reload(event.server)
                    else
                      event.send_temporary_message format(commandLanguage['category']['set']['notexist'], c: args[1]), 10
                    end
                  end
                else
                  event.send_temporary_message format(commandLanguage['category']['set']['notexist'], c: args[1]), 10
                end
              else
                event.send_temporary_message format(commandLanguage['category']['set']['notexist'], c: args[1]), 10
              end
            elsif args.length == 1
              @client.query("UPDATE `uno` SET CATEGORY=NULL WHERE SERVERID=#{event.server.id};")
              event.send_message commandLanguage['category']['set']['remove']
              reload(event.server)
            else
              event.send_temporary_message format(commandLanguage['category']['set']['usage'], u: event.author.username), 10
            end
          else
            event.send_temporary_message format(commandLanguage['notexist'], u: event.author.username), 10
          end
        else
          event.send_temporary_message format(commandLanguage['nopermission'], u: event.author.username), 10
        end
      end
    end
  end

  def help(_user, channel)
    channel.send_temporary_message format(@language.getJson(channel.server.id)['help']), 10
  end
end
