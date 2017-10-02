# frozen_string_literal: true

# require monkeypatched target_audience_filter
require_relative '../../../models/target_audience_filter.rb'
json.target_audience TargetAudienceFilter.identifiers_for_section(@current_section) do |identifier|
  json.identifier identifier
  json.display_name t(".target_audience.#{identifier}")
end

json.exclusive_gender TargetAudienceFiltersOffer::STAMP_FIRST_PART_GENDERS do |identifier|
  json.identifier identifier
  json.display_name t(".exclusive_gender.#{identifier}")
end

json.language LanguageFilter::IDENTIFIER do |identifier|
  json.identifier identifier
  json.display_name t("js.shared.current_and_original_locale.#{identifier}")
end

json.residency_status TargetAudienceFiltersOffer::RESIDENCY_STATUSES do |identifier|
  json.identifier identifier
  json.display_name t(".residency_status.#{identifier}")
end
