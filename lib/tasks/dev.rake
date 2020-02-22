# frozen_string_literal: true

if Rails.env.development? || Rails.env.test?
  require "rubocop/rake_task"
  require 'rspec/core/rake_task'

  RuboCop::RakeTask.new

  namespace :dev do
    desc "Run rubocop"
    task rubocop: :environment do
      puts "\n----------------------------------------"
      puts "Running rubocop on all new code..."
      sh "rubocop -c .rubocop_todo.yml"
    end

    desc "Run rubocop auto correction"
    task rubocopa: :environment do
      puts "\n----------------------------------------"
      puts "Running rubocop auto correct on all new code..."
      sh "rubocop -c .rubocop_todo.yml -a"
    end

    # brakeman
    # gitignoring the brakeman output
    desc 'Run brakeman to scan for security vulnerability in Rails'
    task brakeman: :environment do
      puts "\n----------------------------------------"
      sh 'brakeman -o brakeman_output'
    end

    desc "Generate test coverage report"
    task testcoverage: :environment do
      puts "\n----------------------------------------"
      sh "COVERAGE=on bundle exec rspec"
    end

    # rspec
    RSpec::Core::RakeTask.new(:spec)
  end
end
