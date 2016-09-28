Rails.application.configure do
  # override available_locales to not show Farsi yet - delete this file later!!
  I18n.available_locales = [:de, :en, :ar, :tr, :pl, :ru, :fr]
end
