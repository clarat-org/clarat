# TODO: Change this for proper fix!!
json.age((Offer::MIN_AGE..Offer::MAX_AGE).to_a[0..17]) do |age|
  json.identifier age
  json.display_name t('.age', count: age)
end

# TODO: 0-4 for first 5 family target audiences - Remove this for proper fix!!
json.target_audience TargetAudienceFilter::IDENTIFIER[0..4] do |identifier|
  json.identifier identifier
  json.display_name t(".target_audience.#{identifier}")
end

json.exclusive_gender Offer::EXCLUSIVE_GENDERS do |identifier|
  json.identifier identifier
  json.display_name t(".exclusive_gender.#{identifier}")
end

json.language LanguageFilter::IDENTIFIER do |identifier|
  json.identifier identifier
  json.display_name t("offers.shared.current_and_original_locale.#{identifier}")
end

json.contact_type Offer::CONTACT_TYPES do |identifier|
  json.identifier identifier
  json.display_name t(".contact_type.#{identifier}")
end

json.virtual_encounter Offer::ENCOUNTERS do |identifier|
  next if identifier == 'personal' # 'personal' doubles as a contact type
  json.identifier identifier
  json.display_name t(".encounter.#{identifier}")
end
