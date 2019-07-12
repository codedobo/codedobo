# frozen_string_literal: true

class MainModule
  def userCommand(event)
    event.send_temporary_message('test', 20)
    # if .include? _command
    #   puts 'Exiting application...'
    # end
  end
  end
