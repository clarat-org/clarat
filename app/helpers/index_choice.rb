module IndexChoice
  def self.personal
    if Rails.application.secrets.force_production_index
      "Offer_production_personal_#{I18n.locale}"
    else
      Offer.personal_index_name(I18n.locale)
    end
  end

  def self.remote
    if Rails.application.secrets.force_production_index
      "Offer_production_remote_#{I18n.locale}"
    else
      Offer.remote_index_name(I18n.locale)
    end
  end
end
