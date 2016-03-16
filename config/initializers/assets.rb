Rails.application.configure do
  # Enable the asset pipeline
  config.assets.enabled = true
  config.assets.initialize_on_precompile = false

  # Version of your assets, change this if you want to expire all your assets
  config.assets.version = '1.1.5'

  # Enable fonts directory
  config.assets.paths << Rails.root.join("app", "assets", "fonts")

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  #config.assets.precompile += Dir["app/assets/stylesheets/controller/*.scss"].map{|file| "controller/#{File.basename file,'.scss'}" }
  config.assets.precompile += %w( vendor/modernizr.custom.js )
end
