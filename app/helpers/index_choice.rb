# frozen_string_literal: true
module IndexChoice
  def self.personal
    if Rails.application.secrets.force_production_index
      "Offer_production_personal_#{I18n.locale}"
    else
      "Offer_production_personal_#{I18n.locale}"
    end
  end

  def self.remote
    if Rails.application.secrets.force_production_index
      "Offer_production_remote_#{I18n.locale}"
    else
      "Offer_production_remote_#{I18n.locale}"
    end
  end
end
