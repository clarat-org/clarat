require 'active_record'

namespace :db do
  desc 'Fake some data for development'
  task :fake => :environment do
    Rails.application.load File.join(Rails.root, 'db', 'fake_seeds.rb')
  end
end
