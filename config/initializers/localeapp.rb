require 'localeapp/rails'

Localeapp.configure do |config|
  if ENV['LOCALEAPP_KEY']
    config.api_key = ENV['LOCALEAPP_KEY']
    config.polling_environments = [:development]
  else
    config.api_key = 'none'
    config.polling_environments = []
  end
end
