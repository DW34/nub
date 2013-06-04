#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Nub::Application.load_tasks

Resque.inline = true

require 'resque/tasks'

task "resque:setup" => :environment do
  ENV['QUEUE'] ||= '*'
  #for redistogo on heroku http://stackoverflow.com/questions/2611747/rails-resque-workers-fail-with-pgerror-server-closed-the-connection-unexpectedl
  Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
end

desc "Update intercom with all user data"
task :bulk_update_intercom => :environment do
  Person.order("created_at DESC").each do |person|
    person.update_intercom
    sleep 0.3
  end
  "done"
end

desc "Obfuscate sensitive data"
task :obfuscate => :environment do
  Identity.obfuscate
end