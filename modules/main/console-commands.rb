# frozen_string_literal: true

class MainModule
  def consoleCommand(_command, _args)
    if %w[exit close stop quit].include? _command
      puts 'Exiting application...'
      exit
    end
  end
end
