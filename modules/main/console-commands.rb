# frozen_string_literal: true

require_relative './index.rb'
class MainModule
  include CodeDoBo::BotModule
  def register_stop_command
    @app_class.register_console_cmd(:stop, %w[exit close quit stop]) do |command, args|
      send_message "\u001b[96mExiting application..."
      @module_manager.bot.stop
      send_message "\u001b[32mBye!"
      exit!
    end
  end
  def register_main_command
    @app_class.register_console_cmd(:main, %w[main m]) do |command, args|
      send_message "\u001b[96mRunning main@#{@app_class.properties["version"]} module by #{@app_class.properties["devs"].join(", ")}!"
    end
  end
  def register_restart_command
    @app_class.register_console_cmd(:restart, %w[restart rs rstart res rel rl reload]) do |command, args|
      send_message "\u001b[36mReloading application..."
      @module_manager.bot.restart
      send_message "\u001b[32mSuccessfully reloaded application!"
    end
  end
  def register_console_commands
    register_stop_command
    register_restart_command
    register_main_command
  end
end
