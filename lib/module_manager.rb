# frozen_string_literal: true

require 'json'
class CoDoBo
  # This class handle the modules
  class ModuleManager
    def initialize(cpgui)
      language_dir = File.join(__dir__, '../language')
      @language = CPGUI::Language.new(@config.get('language'), language_dir)
      @command_manager = CPGUI::CommandManager.new(self)
      @cpgui = cpgui
      @modules = []
    end

    # Get all module classes
    # @return [Array(Class)]
    def module_classes
      module_classes = []
      @modules.each do |app_class|
        module_classes.push(app_class.app_module.class)
      end
      module_classes
    end

    # Get all module classes in String
    # @return [Array(String)]
    def module_strings
      module_classes = []
      @modules.each do |app_class|
        module_classes.push(app_class.app_module.class.to_s)
      end
      module_classes
    end

    # Get the app module instance from String
    # @param string [String] Class String
    # @return [CPGUI::AppClass]
    def get_module_by_string(string)
      strings = module_strings
      return nil if strings.index(string).nil?

      @modules[strings.index(string)]
    end

    # Stop the module manager
    # @return [void]
    def stop
      puts "\u001b[36mExiting all modules..."
      @modules.each(&:disable!)
      puts "\u001b[32mSuccessfully exited all modules!"
    end

    # Start the module manager
    # @return [void]
    def start
        @bot.discord.servers.each do |_id, server|
          puts "\u001b[36mJoining server #{server.name}(#{server.id})..."
          join(server, true)
          puts "Successfully joined server #{server.name}(#{server.id})!"
        end
        @bot.discord.server_create do |event|
          puts "\u001b[36mCreating server #{event.server.name}(#{event.server.id})..."
          join(event.server, false)
          puts "Successfully created server #{event.server.name}(#{event.server.id})!"
        end
    end

    # Stop and start the module manager
    # @return [void]
    def restart
      stop
      start
    end

    # Modules from the module manager
    # @return [Array(CPGUI::AppClass)]
    attr_reader :modules

    # Get the help of the module
    # @param app_module_class [Class(CPGUI::AppClass)]
    # @param args [Array(String)]
    # @return [String]
    def help(app_module_class, args)
      modules.each do |app_class|
        next unless app_class == app_module_class

        return app_class.app_module.help(args)
      end
    end

    # Get the module instance of the module class
    # @return [CPGUI::AppModule]
    def get(app_module_class)
      modules.each do |app_module|
        return app_module if app_module.class == app_module_class
      end
    end

    # Detect all modules in folder
    # @return [void]
    def detect
      Dir.foreach('./modules') do |file|
        next if File.directory? file

        add_folder(File.join('./modules', file))
      end
    end

    # Add a folder to the modules
    # @return [void]
    def add_folder(folder)
      return unless File.file? File.join(folder, './module.json')

      json = JSON.parse(File.read(File.join(folder, './module.json')))
      no_comp = @language.get('module', 'no-compactible')
      name = json['name']
      versions = json['compactible']
      no_comp = format(no_comp, module: name, version: versions)
      send_message no_comp unless versions.include? @cpgui.version
      load_folder(folder, json)
    end

    # @param folder [String]
    # @param json [Hash(Hash, Object)]
    def load_folder(folder, json)
      load File.join(folder, json['main']['file'])
      main_class = Object.const_get(json['main']['class'])
      add_module(main_class, json)
    end

    # @param main_class [Class(CPGUI::AppModule)]
    # @param properties [Hash(String)]
    def add_module(main_class, properties)
      adding = @language.get('module', 'adding')
      send_message format(adding, module: main_class.to_s)
      app_class = AppClass.new(properties, main_class, self)
      @modules.push(app_class)
      added = @language.get('module', 'added')
      send_message format(added, module: main_class.to_s)
    end

    # The main class
    # @return [CPGUI]
    attr_reader :cpgui

    # @return [CPGUI::ModuleManager::CommandManager]
    attr_reader :command_manager


    #
    # Run the join command on all modules
    #
    # @param [Discordrb::Server] server
    # @param [TrueClass] already If this server is new for this bot
    #
    # @return [void]
    #
    def join(server, already)
      @modules.each { |botModule| botModule.join(server, already) }
    end

    private

    # Send the message with the prefix
    # @param message [String]
    # @return void
    def send_message(message)
      puts @language.get('console', 'prefix') + message
    end
  end
end
