# frozen_string_literal: true

require_relative '../module.rb'
require_relative './console-commands.rb'
require_relative './user-commands.rb'
class MainModule
  include BotModule
  def initialize; end
end
