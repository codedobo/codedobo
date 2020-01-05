# frozen_string_literal: true

require_relative './index.rb'
class MainModule
  def setup
    send_message "\u001b[96mSet up main module..."
    send_message "\u001b[32mSuccessfully set up main module!"
  end
end
