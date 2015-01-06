Gibbon::API.api_key = Rails.application.secrets.mailchimp['key']
Gibbon::API.timeout = 15
Gibbon::API.throws_exceptions = false
