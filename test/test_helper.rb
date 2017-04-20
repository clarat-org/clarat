ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start 'rails' do
  add_filter "/test/"
  add_filter "/app/policies/application_policy.rb"
  minimum_coverage 100
end

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rails'
require 'minitest/rails/capybara'
require 'minitest/pride'
require 'mocha/mini_test'
require 'capybara/rails'

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/mock'
require 'minitest-matchers'
require 'minitest/hell'
require 'pry-rescue/minitest' if ENV['RESCUE']
require 'sidekiq/testing'
require 'fakeredis'

# Inclusions: First matchers, then modules, then helpers.
# Helpers need to be included after modules due to interdependencies.
Dir[Rails.root.join('test/support/matchers/*.rb')].each { |f| require f }
Dir[Rails.root.join('test/support/modules/*.rb')].each { |f| require f }
Dir[Rails.root.join('test/support/spec_helpers/*.rb')].each { |f| require f }

# For Sidekiq
Sidekiq::Testing.inline!

# Redis
Redis.current = Redis.new
Capybara.asset_host = 'http://localhost:3000'

# For fixtures:
include ActionDispatch::TestProcess

# ~Disable logging for test performance!
# Change this value if you really need the log and run your suite again~
Rails.logger.level = 4

### Test Setup ###
File.open(Rails.root.join('log/test.log'), 'w') { |f| f.truncate(0) } # clearlog

silence_warnings do
  # BCrypt::Engine::DEFAULT_COST = BCrypt::Engine::MIN_COST # needed?
end

Minitest.after_run do
  if $suite_passing
    brakeman
    rails_best_practices
    rubocop
  end
end

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  require 'enumerize/integrations/rspec'
  extend Enumerize::Integrations::RSpec

  fixtures :all

  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
    $suite_passing = false if failure
  end

  # Add more helper methods to be used by all tests here...
end

class MiniTest::Spec
  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean

    $suite_passing = false if failure
  end

  # Add more helper methods to be used by all tests here...
end

$suite_passing = true

DatabaseCleaner.strategy = :transaction

Percy::Capybara.initialize_build
MiniTest.after_run { Percy::Capybara.finalize_build }
