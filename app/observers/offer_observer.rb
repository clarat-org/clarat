class OfferObserver < ActiveRecord::Observer
  def after_initialize offer
    offer.expires_at ||= (Time.zone.now + 1.year) if offer.new_record?
  end

  def before_save offer
    offer.add_approved_info
    offer.generate_html
  end

  def before_create offer
    current_user = ::PaperTrail.whodunnit
    offer.created_by = current_user if current_user.is_a? Integer # so unclean
  end

  def after_create offer
    offer.emails.where(aasm_state: 'subscribed').find_each do |email|
      OfferMailer.delay.new_offer email, offer
    end
  end
end
