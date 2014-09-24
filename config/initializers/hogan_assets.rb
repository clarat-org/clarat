HoganAssets::Config.configure do |config|
  config.lambda_support = true
  #config.template_namespace = 'HoganTemplates'
  config.template_extensions = %w(mustache hamstache)
  config.hamstache_extensions = %w(hamstache)
  config.haml_options[:ugly] = true
end
