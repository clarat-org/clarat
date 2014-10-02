source 'https://rubygems.org'
ruby '2.1.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.5'
gem 'rails-observers' # observers got extracted since rails 4

# Translations
gem 'rails-i18n'

# Plattforms Ruby
platforms :ruby do
  gem 'sqlite3', group: :test # sqlite3 for inmemory testing db
  gem 'therubyracer' # js runtime
  gem 'pg', group: [:production, :development] # postgres
end

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.2'

# More styling
gem 'bootstrap-sass'
gem 'autoprefixer-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Templating for JS
gem 'hogan_assets'
group :assets do
  gem 'haml'
end

# Templating with slim
gem 'slim-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# Background processing
gem 'sidekiq'
gem 'sinatra', '>= 1.3.0', :require => nil # for sidekiq's web interface


group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'rails_admin'

gem 'devise'
# gem 'pundit'
gem 'arcane'

gem 'enumerize'

gem 'paper_trail'

gem 'kaminari' # pagination

# search
gem 'algoliasearch-rails'

gem 'virtus' # form objects
gem 'formtastic'

gem 'friendly_id', '>= 5.0'

gem 'geocoder'

# CSS
gem "font-awesome-rails"

group :production do
  gem 'rails_12factor' #heroku recommends this
end

group :development do
  gem 'spring' # faster rails start

  # errors
  gem 'better_errors'
  gem 'binding_of_caller'

  # debugging in chrome with RailsPanel
  gem 'meta_request'

  # Quiet Assets to disable asset pipeline in log
  gem 'quiet_assets'
end

group :test do
  gem 'coveralls', require: false
  gem 'memory_test_fix'  # Sqlite inmemory fix
  gem 'rake'
end

group :development, :test do
  # debugging
  gem 'pry-rails' # pry is awsome
  gem 'hirb' # hirb makes pry output even more awesome
  gem 'pry-byebug' # kickass debugging
  gem 'pry-stack_explorer'

  # test suite additions
  gem 'rails_best_practices'
  gem 'brakeman'  # security test: execute with 'brakeman'
  gem 'rubocop' # style enforcement

  # dev help
  gem 'thin' # Replace Webrick
  gem 'bullet' # Notify about n+1 queries
end

group :development, :test, :staging do
  gem 'factory_girl_rails'
  gem 'ffaker'
end
