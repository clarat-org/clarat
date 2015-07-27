require 'active_record'

namespace :db do
  desc 'Fake some data for development'
  task fake: :environment do
    Rails.application.load File.join(Rails.root, 'db', 'fake_seeds.rb')
  end

  desc 'seed and fake'
  task seedfake: :environment do
    Rake::Task['db:seed'].invoke
    Rake::Task['db:fake'].invoke
  end

  desc 'Delete schema, reset db'
  task hardreset: :environment do
    Rake::Task['db:drop'].invoke
    File.delete File.join(Rails.root, 'db', 'schema.rb')
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
  end
end
