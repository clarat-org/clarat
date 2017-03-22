source 'https://rubygems.org'
ruby '2.3.3'

gem 'nokogiri', '1.6.7.2' # 1.6.8 doesnt install on some pcs. Remove when fixed

###########
# General #
###########

gem 'clarat_base', github: 'clarat-org/clarat_base'

gem 'bundler', '>= 1.8.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2'

# Translations
gem 'rails-i18n'

# Platforms Ruby
platforms :ruby do
  gem 'sqlite3', group: :test # sqlite3 for inmemory testing db
  gem 'therubyracer' # js runtime
  gem 'pg', group: [:production, :staging, :development] # postgres
end

#######################
# Front-End Specifics #
#######################

gem 'localeapp'

# Puma server
gem 'puma'

##############
# JavaScript #
##############

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# Use jquery as the JavaScript library & plugins
gem 'jquery-rails'
# gem 'qtip2-jquery-rails'

gem 'i18n-js', '>= 3.0.0.rc6' # JS translations

# Templating for JS
gem 'handlebars_assets'
gem 'hamlbars', '~> 2.0'

gem 'hogan_assets' # TODO: deprecated!
group :assets do # TODO: deprecated!
  gem 'haml' # TODO: deprecated!
end # TODO: deprecated!

source 'https://rails-assets.org' do
  gem 'rails-assets-lodash' # (aka underscore) diverse js methods
  gem 'rails-assets-jquery'
  gem 'rails-assets-jquery-cookie'
  gem 'rails-assets-qtip2'
  gem 'rails-assets-shariff'
  gem 'rails-assets-sticky-kit'
  gem 'rails-assets-algoliasearch' # search client
  gem 'rails-assets-isInViewport'
  gem 'rails-assets-iCheck'
  gem 'rails-assets-hammerjs'
  gem 'rails-assets-flexibility'
  gem 'rails-assets-ifvisible.js'
end

#######
# CSS #
#######

gem 'font-awesome-rails'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.2'

# More styling
gem 'bootstrap-sass'
gem 'autoprefixer-rails'

#########
# Other #
#########

# Templating with slim
gem 'slim-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Rack-Based

gem 'rack-attack' # securing malicious requests
gem 'rack-rewrite' # securing malicious requests

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# Pretty print your Ruby objects with style
gem 'awesome_print'

# gem 'rails_admin_clone' # must come before rails_admin to work correctly
# gem 'rails_admin'
# gem 'rails_admin_nested_set'
# gem 'rails_admin_nestable'
# gem 'cancan' # role based auth for rails_admin

# gem 'devise'
# gem 'omniauth-facebook'
# gem 'omniauth-google-oauth2'
gem 'pundit'
gem 'arcane', '1.1.1'
gem 'kaminari' # pagination

gem 'route_translator'
gem 'dynamic_sitemaps', github: 'efqdalton/dynamic_sitemaps',
                        branch: 'adds-custom-storages'

# Model enhancements

gem 'virtus' # form objects
gem 'formtastic'
gem 'simple_form'

# cells for ViewModel in Rails
gem 'cells', '~> 4.0.0'
gem 'cells-slim'

########################
# For Heroku & Add-Ons #
########################

gem 'newrelic_rpm'
gem 'rack-cache'
gem 'memcachier'
gem 'dalli' # Memcached Client
gem 'kgio'

group :production, :staging do
  gem 'rails_12factor' # heroku recommends this
  gem 'heroku-deflater' # gzip compression
end

# email
gem 'gibbon', '~> 1.2.0' # uses MailChimp API 2.0, remove version for 3.0+

# Logging
gem 'lograge' # opinionated slimmer logs for production

#####################
# Dev/Test Specific #
#####################

group :development do
  # startup
  gem 'spring' # faster rails start

  # errors
  gem 'better_errors'
  gem 'binding_of_caller'

  # debugging in chrome with RailsPanel
  gem 'meta_request'

  # Quiet Assets to disable asset pipeline in log
  gem 'quiet_assets'

  # requires graphviz to generate
  # entity relationship diagrams
  gem 'rails-erd', require: false
end

group :test do
  gem 'memory_test_fix' # Sqlite inmemory fix
  gem 'rake'
  gem 'database_cleaner'
  # gem 'colorize' # use this when RBP quits using `colored`
  gem 'fakeredis'
  gem 'fakeweb', '~> 1.3'
  gem 'webmock'
  gem 'pry-rescue'

  # testing emails
  gem 'email_spec'
end

group :development, :test do
  # debugging
  gem 'pry-rails' # pry is awsome
  gem 'hirb' # hirb makes pry output even more awesome
  gem 'pry-byebug' # kickass debugging
  gem 'pry-stack_explorer' # step through stack
  gem 'pry-doc' # read ruby docs in console

  # test suite
  gem 'minitest' # Testing using Minitest
  gem 'minitest-matchers'
  gem 'minitest-line'
  gem 'launchy' # save_and_open_page
  gem 'shoulda'
  gem 'minitest-rails-capybara'
  gem 'mocha'

  # test suite additions
  gem 'rails_best_practices'
  gem 'brakeman' # security test: execute with 'brakeman'
  gem 'rubocop' # style enforcement

  # Code Coverage
  gem 'simplecov', require: false
  gem 'coveralls', require: false

  # dev help
  gem 'thin' # Replace Webrick
  gem 'bullet' # Notify about n+1 queries
  gem 'letter_opener' # emails in browser
  gem 'timecop' # time travel!
  gem 'dotenv-rails' # handle environment variables
end

group :development, :test, :staging do
  gem 'factory_girl_rails'
  gem 'ffaker'
end
