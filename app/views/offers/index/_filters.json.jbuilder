json.age((Offer::MIN_AGE..Offer::MAX_AGE).to_a) do |age|
  json.identifier age
  json.display_name t('.age', count: age)
end

json.target_audience TargetAudienceFilter.find_each do |filter|
  json.identifier filter.identifier
  json.display_name t(".target_audience.#{filter.identifier}")
  json.section filter.section_filter.identifier
end

json.exclusive_gender Offer::EXCLUSIVE_GENDERS do |identifier|
  json.identifier identifier
  json.display_name t(".exclusive_gender.#{identifier}")
end

json.language LanguageFilter::IDENTIFIER do |identifier|
  json.identifier identifier
  json.display_name t(".language.#{identifier}")
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
