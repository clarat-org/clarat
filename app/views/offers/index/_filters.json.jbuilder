json.age((0..18).to_a) do |age|
  json.identifier age
  json.display_name t('.age', count: age)
end

json.target_audience TargetAudienceFilter::IDENTIFIER do |identifier|
  json.identifier identifier
  json.display_name t(".target_audience.#{identifier}")
end

json.target_gender Offer::EXCLUSIVE_GENDERS do |identifier|
  json.identifier identifier
  json.display_name t(".target_gender.#{identifier}")
end

json.language LanguageFilter::IDENTIFIER do |identifier|
  json.identifier identifier
  json.display_name t(".language.#{identifier}")
end

json.encounter Offer::ENCOUNTERS do |identifier|
  json.identifier identifier
  json.display_name t(".encounter.#{identifier}")
end
