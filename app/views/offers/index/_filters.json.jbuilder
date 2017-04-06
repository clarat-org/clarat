# TODO: Change this for proper fix!!
json.age((Offer::MIN_AGE..Offer::MAX_AGE).to_a[0..17]) do |age|
  json.identifier age
  json.display_name t('.age', count: age)
end

# HOTFIX: 0-4 for first 5 family target audiences
json.target_audience TargetAudienceFilter::IDENTIFIER[0..4] do |identifier|
  json.identifier identifier
  json.display_name t(".target_audience.#{identifier}")
end

json.gender_first_part_of_stamp Offer::BENEFICIARY_GENDERS do |identifier|
  json.identifier identifier
  json.display_name t(".gender_first_part_of_stamp.#{identifier}")
end

json.language LanguageFilter::IDENTIFIER do |identifier|
  json.identifier identifier
  json.display_name t("js.shared.current_and_original_locale.#{identifier}")
end

json.contact_type Offer::CONTACT_TYPES do |identifier|
  json.identifier identifier
  json.display_name t(".contact_type.#{identifier}")
end

# HOTFIX: 0-6 for first 6 encounters (except personal)
json.virtual_encounter Offer::ENCOUNTERS[0..6] do |identifier|
  next if identifier == 'personal' # 'personal' doubles as a contact type
  json.identifier identifier
  json.display_name t(".encounter.#{identifier}")
end
