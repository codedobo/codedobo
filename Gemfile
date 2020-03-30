# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# gem "rails"
gem 'discordrb'
gem 'ruby'
gem 'mysql2'
gem 'sequel'

Dir.foreach('./modules') do |file|
  next if File.directory? file
  gem_file = File.join(File.join('./modules', file), 'Gemfile')
  next unless File.exist? gem_file

  eval_gemfile gem_file
end
