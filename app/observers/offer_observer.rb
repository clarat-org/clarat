class OfferObserver < ActiveRecord::Observer
  def before_save offer
    offer.add_approved_info
  end

  def before_create offer
    current_user = ::PaperTrail.whodunnit
    offer.created_by = current_user.id if current_user # so unclean ...
  end

  def after_save offer
    offer.prevent_duplicate_tags
  end
end
