class OfferObserver < ActiveRecord::Observer
  def after_initialize offer
    offer.expires_at ||= (Time.zone.now + 1.year) if offer.new_record?
  end

  def before_save offer
    offer.generate_html!
  end

  def before_create offer
    return if offer.created_by
    current_user = ::PaperTrail.whodunnit
    offer.created_by = current_user if current_user.is_a? Integer # so unclean
  end
end
