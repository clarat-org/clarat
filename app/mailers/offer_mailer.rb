class OfferMailer < ActionMailer::Base
  def expiring_mail offer_id
    @offer = Offer.find(offer_id)
    mail subject: 'EXPIRING OFFER',
         to:      'TODO',
         from:    'noreply@clarat.org'
  end
end
