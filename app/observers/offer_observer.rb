class OfferObserver < ActiveRecord::Observer
  def after_initialize offer
    offer.expires_at ||= (Time.now + 1.year) if offer.new_record?
  end

  def before_save offer
    offer.add_approved_info
  end

  def before_create offer
    current_user = ::PaperTrail.whodunnit
    offer.created_by = current_user.id if current_user # so unclean ...
  end
end
