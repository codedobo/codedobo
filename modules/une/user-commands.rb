# frozen_string_literal: true

require_relative './index.rb'
class UnoModule
  def message(event); end

  def userCommand(command, args, event)
    commandLanguage = @language.getJson(event.server.id)['commands']
    if commandLanguage['uno']['aliases'].include? command
      if args.empty?
        output = commandLanguage['uno']['output']
        event << format(output, v: module_version)
      else
        if event.user.permission? :administrator
          case args[0]
          when *commandLanguage['help']['aliases']
            event << format(commandLanguage['help']['output'], u: event.author.username)
          when *commandLanguage['category']['get']['aliases']
            if args.length == 1
              @client.query("SELECT * FROM `uno` WHERE SERVERID=#{event.server.id}").each do |row|
                if row['CATEGORY'].nil?
                  event << format(commandLanguage['category']['get']['no'])
                else
                  channel = event.bot.channel(row['CATEGORY'].to_i)
                  if channel.nil?
                    event << format(commandLanguage['category']['get']['no'])
                  else
                    event << format(commandLanguage['category']['get']['output'], c: channel.name, i: channel.id)
                  end
                end
              end
            else
              event << format(commandLanguage['category']['get']['usage'])
            end
          when *commandLanguage['category']['set']['aliases']
            if args.length == 2
              if args[1].numeric?
                channel = event.bot.channel(args[1].to_i, event.server)
                if channel.server.id == event.server.id
                  if channel.nil?
                    event << format(commandLanguage['category']['set']['notexist'], c: channel.name, i: channel.id)
                  else
                    if channel.category?
                      @client.query("UPDATE `uno` SET CATEGORY=#{channel.id} WHERE SERVERID=#{channel.server.id};")
                      event.send_message format(commandLanguage['category']['set']['output'], c: channel.name, i: channel.id)
                      reload(event.server)
                    else
                      event << format(commandLanguage['category']['set']['notexist'], c: args[1])
                    end
                  end
                else
                  event << format(commandLanguage['category']['set']['notexist'], c: args[1])
                end
              else
                event << format(commandLanguage['category']['set']['notexist'], c: args[1])
              end
            elsif args.length == 1
              @client.query("UPDATE `uno` SET CATEGORY=NULL WHERE SERVERID=#{event.server.id};")
              event.send_message commandLanguage['category']['set']['remove']
              reload(event.server)
            else
              event << format(commandLanguage['category']['set']['usage'], u: event.author.username)
            end
          else
            event << format(commandLanguage['notexist'], u: event.author.username)
          end
        else
          event << format(commandLanguage['nopermission'], u: event.author.username)
        end
      end
    end
  end

  def help(_user, channel)
    channel << format(@language.getJson(channel.server.id)['help'])
  end
end
